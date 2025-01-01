defmodule PhoenixBankingApp.Services.AuthService do

  alias PhoenixBankingApp.Dwolla.Dwolla
  alias PhoenixBankingApp.Dwolla.Customer
  alias PhoenixBankingApp.Plaid.Item
  alias PhoenixBankingApp.Plaid.Accounts
  alias PhoenixBankingApp.Utils.CryptoUtil
  alias PhoenixBankingApp.Constants.EnvKeysFetcher
  alias PhoenixBankingApp.Dwolla.Token
  alias Appwrite.Services.Database



  @spec exchange_public_token(any(), any()) :: {:ok, %{publicTokenExchange: <<_::64>>}}
  def exchange_public_token(public_token, socket) do
    try do
      user = socket.assigns.user

      {:ok, public_token_exchange_res} = Item.exchange_public_token(%{public_token: public_token})

      IO.inspect(public_token_exchange_res, label: "public_token_exchange_res")

      {:ok, accounts_res} =
        Accounts.get(%{access_token: public_token_exchange_res[:access_token]})

      IO.inspect(accounts_res, label: "accounts_res")

      account_data = Enum.at(accounts_res.accounts, 0)

      IO.inspect(account_data, label: "account_data")

      #  Create a processor token for Dwolla using the access token and account ID
      processor_token_create_request_params = %{
        access_token: public_token_exchange_res[:access_token],
        account_id: account_data.account_id,
        processor: "dwolla"
      }

      IO.inspect(processor_token_create_request_params,
        label: "processor_token_create_request_params"
      )

      {:ok, processor_token_create_response} =
        Item.create_processor_token(processor_token_create_request_params, %{})

      IO.inspect(processor_token_create_response, label: "processor_token_create_response")

      dwolla_creds = %{client_id: Dwolla.get_client_id(), client_secret: Dwolla.get_client_secret()}

      {:ok, dwolla_token_details} = Token.get(dwolla_creds)


      {:ok, funding_source_response} =
        Customer.create_funding_source(
          dwolla_token_details.access_token,
          user["dwolla_id"],
          %{
            name: account_data.name,
            plaidToken: processor_token_create_response[:processor_token]
          }
        )

      IO.inspect(funding_source_response, label: "funding_source_response")

      bank_data = %{
        "user_id" => user["user_id"],
        "bank_id" => public_token_exchange_res[:item_id],
        "bank_name" => account_data.name,
        "funding_source_id" => funding_source_response[:id],
        # shareable_id" => CryptoUtil.encrypt(account_data.account_id),
        "shareable_id" =>  account_data.account_id,
         "access_token" => public_token_exchange_res[:access_token]
      }

      IO.inspect(bank_data)

      bank_doc =
        Database.create_document(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_bank_collection_id(),
          user["user_id"],
          bank_data,
          nil
        )

      IO.inspect(bank_doc, label: "bank_doc")

      {:ok,
       %{
         publicTokenExchange: "complete"
       }}
    catch
      {:error, error} ->
        IO.inspect(error)
        raise error
    end
  end


end
