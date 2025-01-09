defmodule PhoenixBankingAppWeb.TransactionHistoryLive.Show do
  use PhoenixBankingAppWeb, :live_view
  alias PhoenixBankingApp.Services.BankService
  alias PhoenixBankingApp.Services.AuthService

  @impl true
  def mount(params, _session, socket) do
    # {:ok, user_details} = get_user_data(params)
    # user_id = Enum.at(user_details["documents"], 0)["user_id"]
    # {:ok, accounts} = get_accounts_data(user_id)
    # IO.inspect(accounts)

    # bank_id = get_bank_id(params, accounts[:data])




    {:ok, account_res} = get_account_data("c8c5267936784c9883a2dcf64a6c643e")
    IO.inspect(account_res)

    {:ok,
     socket
    #  |> assign(:accounts_data, accounts[:data])
    #  |> assign(:logged_in, Enum.at(user_details["documents"], 0))
       |> assign(:appwrite_item_id, get_bank_id(params, [account_res[:account]]))
      |> assign(:account, account_res[:account])
      |> assign(:transactions, account_res[:transaction])

     |> assign(:current_url, "/transaction-history")
    }
  end

  @impl true
  def handle_params(_unsigned_params, uri, socket) do
    {:noreply, socket
    |>   assign(:url, uri)
  }
  end

  def format_amount(amount) when is_number(amount) do
    Number.Currency.number_to_currency(amount, unit: "$", precision: 2)
  end

  defp get_user_data(params) do
    case AuthService.get_logged_in_user(params["key"]) do
      {:ok, user} ->
        {:ok, user}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec get_accounts_data(any()) ::
          {:error, any()}
          | {:ok, %{data: list(), total_banks: non_neg_integer(), total_current_balance: any()}}
  defp get_accounts_data(user_id) do
    case BankService.get_accounts(user_id) do
      {:ok, accounts} -> {:ok, accounts}
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_account_data(bank_id) do
    case BankService.get_account(bank_id) do
      {:ok, account} -> {:ok, account}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_bank_id(params, accounts) do
    case params do
      %{"id" => id} ->
        # Process the id as needed
        id

      %{} ->
        # Handle the absence of the "id" parameter
        # For example, assign a default value or redirect
        Enum.at(accounts, 0)[:appwrite_item_id]
    end
  end
end
