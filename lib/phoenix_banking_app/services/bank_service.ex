defmodule PhoenixBankingApp.Services.BankService do
  alias PhoenixBankingApp.Plaid.Transactions
  alias PhoenixBankingApp.Plaid.Investments.Transactions.Transaction
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

      accounts =
        Enum.map(banks, fn bank ->
          {:ok, accounts_res} =
            Accounts.get(%{access_token: bank[:access_token]})

          account_data = Enum.at(accounts_res.accounts, 0)
          {:ok, institution} = get_institution(accounts_res.item.institution_id)

          account = %{
            id: account_data.account_id,
            available_balance: account_data.balances.available,
            current_balance: account_data.balances.current,
            institution_id: institution.institution_id,
            name: account_data.name,
            official_name: account_data.official_name,
            mask: account_data.mask,
            type: account_data.typ,
            sub_type: account_data.subtype,
            appwrite_item_id: bank["$id"],
            sharaeble_id: bank.shareableId
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
      {:ok, bank} = get_bank(appwrite_item_id)

      {:ok, accounts_res} =
        Accounts.get(%{access_token: bank[:access_token]})

      account_data = Enum.at(accounts_res.accounts, 0)

      {:ok, transfer_trasaction_data} = Transaction.get_transactions_by_bank_id(bank["$id"])

      transfer_transactions =
        Enum.map(transfer_trasaction_data, fn transfer_data ->
          %{
            id: transfer_data["$id"],
            name: transfer_data["name"],
            amount: transfer_data["amount"],
            date: transfer_data["created_at"],
            paymentChannel: transfer_data["channel"],
            category: transfer_data["category"],
            type: if(transfer_data["sender_bank_id"] == bank["$id"], do: "debit", else: "credit")
          }
        end)

      {:ok, institution} = get_institution(accounts_res.item.institution_id)

      {:ok, bank_transactions} = get_transactions(bank[:access_token])

      account = %{
        id: account_data.account_id,
        available_balance: account_data.balances.available,
        current_balance: account_data.balances.current,
        institution_id: institution.institution_id,
        name: account_data.name,
        official_name: account_data.official_name,
        mask: account_data.mask,
        type: account_data.typ,
        sub_type: account_data.subtype,
        appwrite_item_id: bank["$id"],
        sharaeble_id: bank.shareableId
      }

      all_transactions =
        (bank_transactions ++ transfer_transactions)
        |> Enum.sort_by(&Date.from_iso8601!(&1.date), :desc)

     {:ok,  %{account: account, transaction: all_transactions}}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_institution(institution_id) do
    try do
      institution =
        Institutions.get_by_id(%{
          institution_id: institution_id,
          country_codes: ["US"]
        })

      {:ok, institution}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_banks(user_id) do
    try do
      banks =
        Database.list_documents(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_bank_collection_id(),
          [Jason.decode!(Query.equal("user_id", [user_id]))]
        )

      {:ok, banks}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_bank(document_id) do
    try do
      bank =
        Database.list_documents(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_bank_collection_id(),
          [Jason.decode!(Query.equal("$id", [document_id]))]
        )

      {:ok, bank}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def get_transactions(access_token) do
    fetch_transactions(access_token, true, [])
    |> Enum.reverse()
  end

  defp fetch_transactions(_access_token, false, transactions), do: transactions

  defp fetch_transactions(access_token, true, transactions) do
    Transactions.sync(%{
      access_token: access_token,
      count: 20,
      cursor: "last-request-cursor-value"
    })

    case Transactions.sync(%{
           access_token: access_token,
           count: 20,
           cursor: "last-request-cursor-value"
         }) do
      {:ok, transactions} ->
        new_transactions =
          Enum.map(transactions["added"], fn transaction ->
            %{
              id: transaction["transaction_id"],
              name: transaction["name"],
              payment_channel: transaction["payment_channel"],
              type: transaction["payment_channel"],
              account_id: transaction["account_id"],
              amount: transaction["amount"],
              pending: transaction["pending"],
              category: List.first(transaction["category"] || []),
              date: transaction["date"],
              image: transaction["logo_url"]
            }
          end)

        fetch_transactions(
          access_token,
          transactions["has_more"],
          new_transactions ++ transactions
        )

      {:error, error} ->
        IO.puts("An error occurred while getting the transactions: #{inspect(error)}")
        transactions
    end
  end
end
