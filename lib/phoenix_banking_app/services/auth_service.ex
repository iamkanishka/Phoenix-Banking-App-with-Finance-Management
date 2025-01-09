defmodule PhoenixBankingApp.Services.AuthService do
  alias PhoenixBankingApp.Utils.SessionManager
  alias Appwrite.Utils
  alias Appwrite.Utils.Query
  alias Appwrite.Types.Document
  alias PhoenixBankingApp.Dwolla.Dwolla
  alias PhoenixBankingApp.Dwolla.Customer
  alias PhoenixBankingApp.Plaid.Item
  alias PhoenixBankingApp.Plaid.Accounts, as: PlaidAccounts
  alias Appwrite.Services.Accounts, as: AppwriteAccounts
  alias PhoenixBankingApp.Utils.CryptoUtil
  alias PhoenixBankingApp.Constants.EnvKeysFetcher
  alias PhoenixBankingApp.Dwolla.Token
  alias Appwrite.Services.Database

  @form_fields [
    %{field: :first_name, label: "First Name", type: "text", placeholder: "First Name"},
    %{field: :last_name, label: "Last Name", type: "text", placeholder: "Last Name"},
    %{field: :address1, label: "Address", type: "text", placeholder: "123, Main St"},
    %{field: :city, label: "City", type: "text", placeholder: "Your City"},
    %{field: :state, label: "State", type: "text", placeholder: "NY"},
    %{field: :postal_code, label: "Postal Code", type: "text", placeholder: "50314"},
    %{field: :date_of_birth, label: "Date Of Birth", type: "date", placeholder: "YYYY-MM-DD"},
    %{field: :ssn, label: "SSN", type: "text", placeholder: "123-45-6789"},
    %{field: :email, label: "Email", type: "text", placeholder: "your_email@example.com"},
    %{field: :password, label: "Password", type: "text", placeholder: "Your Password"}
  ]

  def sign_in(email, password) do
    try do
      {:ok, user_auth_data} =
        AppwriteAccounts.create_email_password_session(email, password)

      SessionManager.put_session(
        user_auth_data["userId"],
        user_auth_data["secret"]
      )

      {:ok, need_bank_connectivity } = check_user_bank_connectivity(user_auth_data)

      if need_bank_connectivity do
        {:ok, user_doc} = check_user_existence(user_auth_data["userId"])

        notify_parent({:user, user_doc})

        {:ok, need_bank_connectivity, user_auth_data["userId"]}
      else
        {:ok, need_bank_connectivity, user_auth_data["userId"]}
      end
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def sign_up(user_data) do
    try do
      full_name = "#{user_data["first_name"]} #{user_data["last_name"]}"

      {:ok, new_user} =
        AppwriteAccounts.create(nil, user_data["email"], user_data["password"], full_name)

      atomized_user_data = Map.new(user_data, fn {key, value} -> {String.to_atom(key), value} end)

      # Update the User state
      updated_user_state_data = update_user_state_field(atomized_user_data)

      dwolla_creds = %{
        client_id: Dwolla.get_client_id(),
        client_secret: Dwolla.get_client_secret()
      }

      {:ok, dwolla_token_details} = Token.get(dwolla_creds)

      {:ok, dwolla_id} =
        Customer.create_verified(dwolla_token_details.access_token, updated_user_state_data)

      {:ok, user_session} =
        AppwriteAccounts.create_email_password_session(user_data["email"], user_data["password"])

     updated_user_data =
        Map.merge(user_data, %{"dwolla_id" => dwolla_id[:id], "user_id" => new_user["$id"]})

      IO.inspect(updated_user_data, label: "updated_user_data")

      {:ok, user_doc} = add_user(updated_user_data)

      IO.inspect(user_doc, label: "user_doc")

      SessionManager.put_session(
        user_session["userId"],
        user_session["secret"]
      )


      notify_parent({:user, user_doc})
      {:ok, user_doc}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  defp update_user_state_field(user_data) do
    # Update the User state with two letter and capitalize it
    Map.update!(user_data, :state, fn state ->
      state
      # Take the first 2 characters
      |> String.slice(0, 2)
      # Convert them to uppercase
      |> String.upcase()
    end)
  end

  defp notify_parent(msg), do: send(self(), msg)

  defp add_user(user_data) do
    # Add user to database
    Database.create_document(
      EnvKeysFetcher.get_appwrite_database_id(),
      EnvKeysFetcher.get_user_collection_id(),
      user_data["user_id"],
      user_data,
      nil
    )
  end

  def get_logged_in_user(session_key) do
    {:ok, session} = SessionManager.get_session(session_key)

    case AppwriteAccounts.get(%{"X-Appwrite-Session" => session}) do
      {:ok, user} ->
        case get_user_info(user["$id"]) do
          {:ok, user_details} ->
            {:ok, user_details}

          {:error, error} ->
            IO.inspect(error)
            {:error, error}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  def exchange_public_token(public_token, socket) do
    try do
      user = socket.assigns.user

      {:ok, public_token_exchange_res} = Item.exchange_public_token(%{public_token: public_token})

      IO.inspect(public_token_exchange_res, label: "public_token_exchange_res")

      {:ok, accounts_res} =
        PlaidAccounts.get(%{access_token: public_token_exchange_res[:access_token]})

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

      dwolla_creds = %{
        client_id: Dwolla.get_client_id(),
        client_secret: Dwolla.get_client_secret()
      }

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
        "shareable_id" => account_data.account_id,
        "processor_token" => processor_token_create_response[:processor_token],
        "account_id" => account_data.account_id,
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

  def check_user_bank_connectivity(user_auth_data) do
    try do
      {:ok, user_bank_data} =
        Database.get_document(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_bank_collection_id(),
          user_auth_data["userId"],
          nil
        )

      need_connectivity =
        if Map.has_key?(user_bank_data, "code") and user_bank_data["code"] == 404,
          do: true,
          else: false

      {:ok, need_connectivity}
    catch
      {:error, error} ->
        IO.inspect(error)
        {:error, false}
    end
  end

  defp check_user_existence(user_id) do
    Database.get_document(
      EnvKeysFetcher.get_appwrite_database_id(),
      EnvKeysFetcher.get_user_collection_id(),
      user_id,
      nil
    )
  end

  defp get_user_info(user_id) do
    get_user =
      Database.list_documents(
        EnvKeysFetcher.get_appwrite_database_id(),
        EnvKeysFetcher.get_user_collection_id(),
        [Query.equal("user_id", [user_id])]
      )

    case get_user do
      {:ok, user_docs} ->
        {:ok, user_docs}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_form_fields do
    @form_fields
  end
end
