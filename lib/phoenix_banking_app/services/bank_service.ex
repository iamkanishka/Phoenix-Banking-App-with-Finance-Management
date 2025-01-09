defmodule PhoenixBankingApp.Services.BankService do
  alias PhoenixBankingApp.Utils.DateUtil
  alias PhoenixBankingApp.Services.TransactionService
  alias PhoenixBankingApp.Dwolla.Transfer
  alias PhoenixBankingApp.Plaid.Transactions
  # alias PhoenixBankingApp.Plaid.Investments.Transactions.Transaction
  alias PhoenixBankingApp.Plaid.Institutions
  alias PhoenixBankingApp.Plaid
  alias Appwrite.Utils.Query
  alias PhoenixBankingApp.Plaid.Accounts
  alias PhoenixBankingApp.Constants.EnvKeysFetcher
  alias Appwrite.Types.DocumentList
  alias Appwrite.Services.Database

  def get_accounts(user_id) do
    try do
      {:ok, banks} = get_banks(user_id)
      IO.inspect(banks)

      accounts =
        Enum.map(banks["documents"], fn bank ->
          {:ok, accounts_res} =
            Accounts.get(%{access_token: bank["access_token"]})
            IO.inspect(accounts_res)

          account_data = Enum.at(accounts_res.accounts, 0)
      # for account_data <- accounts_res.accounts do

          {:ok, institution} = get_institution(accounts_res.item.institution_id)

          account = %{
            id: account_data.account_id,
            available_balance: account_data.balances.available,
            current_balance: account_data.balances.current,
            institution_id: institution.institution_id,
            display_name: "#{account_data.name}(#{account_data.balances.available})",
            name: account_data.name,
            official_name: account_data.official_name,
            mask: account_data.mask,
            type: account_data.type,
            sub_type: account_data.subtype,
            funding_source: bank["funding_source_id"],
            appwrite_item_id: bank["$id"],
            sharaeble_id: bank["shareable_id"],
            user_id: user_id
          }

          account
        end)

      total_banks = length(accounts)

      total_current_balance =
        Enum.reduce(accounts, 0.0, fn account, total ->
          total + account.current_balance
        end)

      {:ok,
       %{data: accounts, total_banks: total_banks, total_current_balance: total_current_balance}}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_account(appwrite_item_id) do
    try do
      {:ok, bank_data} = get_bank(appwrite_item_id)

      IO.inspect(bank_data)

      bank = Enum.at(bank_data["documents"], 0)
      IO.inspect(bank)

      {:ok, accounts_res} =
        Accounts.get(%{access_token: bank["access_token"]})

      account_data = Enum.at(accounts_res.accounts, 0)

      {:ok, transfer_trasaction_data} =
        TransactionService.get_transactions_by_bank_id(bank["$id"])

      IO.inspect(transfer_trasaction_data)

      transfer_transactions =
        Enum.map(transfer_trasaction_data[:documents], fn transfer_data ->
          %{
            id: transfer_data["$id"],
            name: transfer_data["name"],
            amount: transfer_data["amount"] |> String.to_float() |> trunc(),
            date: transfer_data["$createdAt"],
            payment_channel: transfer_data["channel"],
            category: transfer_data["category"],
            type: if(transfer_data["sender_bank_id"] == bank["$id"], do: "debit", else: "credit")
          }
        end)

      {:ok, institution} = get_institution(accounts_res.item.institution_id)

      IO.inspect(bank["processor_token"])
      {:ok, bank_transactions} = get_transactions(bank["processor_token"])

      IO.inspect(bank_transactions)

      account = %{
        id: account_data.account_id,
        available_balance: account_data.balances.available,
        current_balance: account_data.balances.current,
        institution_id: institution.institution_id,
        name: account_data.name,
        official_name: account_data.official_name,
        mask: account_data.mask,
        type: account_data.type,
        sub_type: account_data.subtype,
        appwrite_item_id: bank["$id"],
        sharaeble_id: bank["shareable_id"]
      }

      all_transactions =
        bank_transactions ++ transfer_transactions

      # |> Enum.sort_by(&Date.from_iso8601!(&1.date), :desc)

      {:ok, %{account: account, transaction: all_transactions}}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_institution(institution_id) do
    try do
      Institutions.get_by_id(%{
        institution_id: institution_id,
        country_codes: ["US"]
      })
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_banks(user_id) do
    try do
      Database.list_documents(
        EnvKeysFetcher.get_appwrite_database_id(),
        EnvKeysFetcher.get_bank_collection_id(),
        [Query.equal("user_id", [user_id])]
      )
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_bank(document_id) do
    try do
      Database.list_documents(
        EnvKeysFetcher.get_appwrite_database_id(),
        EnvKeysFetcher.get_bank_collection_id(),
        [Query.equal("$id", [document_id])]
      )
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_transactions(processor_token) do
    IO.inspect(processor_token)
    transaction_data = fetch_transactions(processor_token, true, [], 0) |> Enum.reverse()
    {:ok, transaction_data}
    # IO.inspect(fetch_transactions(processor_token, true, []))
    # IO.inspect(fetch_transactions(processor_token, true, []) |> Enum.reverse())
  end

  defp fetch_transactions(_access_token, false, transactions, count), do: transactions

  defp fetch_transactions(processor_token, true, transactions_data, count) do
    count = count + 1
    IO.inspect(processor_token)

    request = %{
      processor_token: processor_token,
      count: 20
      # cursor: "last-request-cursor-value"
    }

    IO.inspect(request)

    case Transactions.sync(request) do
      {:ok, %PhoenixBankingApp.Plaid.Transactions.Sync{added: transactions, has_more: has_more}} ->
        new_transactions =
          Enum.map(transactions, fn transaction ->
            %{
              id: transaction.transaction_id,
              name: transaction.name,
              payment_channel: transaction.payment_channel,
              type: transaction.payment_channel,
              account_id: transaction.account_id,
              amount: transaction.amount,
              pending: transaction.pending,
              category: List.first(transaction.category || []),
              date: transaction.date
              # image: transaction.logo_url
            }
          end)

    IO.inspect(count)

        has_more = if count == 5, do: false, else: has_more
       IO.inspect(length(new_transactions ++ transactions_data))

        fetch_transactions(
          processor_token,
          has_more,
          new_transactions ++ transactions_data,
          count
        )

      {:error, error} ->
        IO.puts("An error occurred while getting the transactions: #{inspect(error)}")
        transactions_data
    end
  end

  def create_transfer(token, transfer_params) do
    try do
      transfer_request_body = %{
        _links: %{
          source: %{
            href:
              "https://api-sandbox.dwolla.com/funding-sources/#{transfer_params[:source_funding_source]}"
          },
          destination: %{
            href:
              "https://api-sandbox.dwolla.com/funding-sources/#{transfer_params[:destination_funding_source]}"
          }
        },
        amount: %{
          currency: "USD",
          value: transfer_params[:amount]
        }
      }

      IO.inspect(transfer_request_body)

      Transfer.initiate(token, transfer_request_body)
    catch
      {:error, error} ->
        {:error, "Tranfer Process Failed" + error}
    end
  end

  def get_bank_by_account_id(account_id) do
    try do
      Database.list_documents(
        EnvKeysFetcher.get_appwrite_database_id(),
        EnvKeysFetcher.get_bank_collection_id(),
        [Query.equal("account_id", [account_id])]
      )
    catch
      {:error, error} ->
        {:error, error}
    end
  end
end
