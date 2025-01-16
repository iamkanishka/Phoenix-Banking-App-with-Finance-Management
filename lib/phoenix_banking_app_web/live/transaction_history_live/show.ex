defmodule PhoenixBankingAppWeb.TransactionHistoryLive.Show do
  alias PhoenixBankingAppWeb.CustomComponents.Pagination
  use PhoenixBankingAppWeb, :live_view
  alias PhoenixBankingApp.Services.BankService
  alias PhoenixBankingApp.Services.AuthService

  @impl true
  def mount(params, _session, socket) do
    send(self(), {:load_critical_data, params})

    {:ok,
     socket
     |> assign(:key, params["key"])
     |> assign(:current_url, "/transaction-history/")
     |> assign(:is_loading, true)
     |> assign(:appwrite_item_id, "")
     |> assign(:logged_in, %{})
     |> assign(:account, %{})
     |> assign(:transactions, [])}
  end

  @impl true
  def handle_params(unsigned_params, uri, socket) do
    {:noreply,
     socket
     |> assign(:page, get_page(unsigned_params, 1))
     |> assign(:url, uri)}
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

  @impl true
  def handle_info({:load_critical_data, params}, socket) do
    {:ok, user_details} = get_user_data(params)
    user_id = Enum.at(user_details["documents"], 0)["user_id"]
    {:ok, accounts} = get_accounts_data(user_id)

    {:ok, account_res} = get_account_data(get_bank_id(params, accounts[:data]))
    pagination = Pagination.paginate(account_res[:transaction], socket.assigns.page, 10)

    {:noreply,
     socket
     |> assign(:appwrite_item_id, get_bank_id(params, accounts[:data]))
     |> assign(:account, account_res[:account])
     |> assign(:logged_in, Enum.at(user_details["documents"], 0))
     |> assign(:transactions, pagination[:current_transactions])
     |> assign(:total_pages, pagination[:total_pages])
     |> assign(:is_loading, false)}
  end

  def get_page(params, default_page \\ 1) do
    case params do
      %{"page" => page} ->
        # Return the page value from params
        page

      %{} ->
        # Return the default page if "page" key is not present
        default_page
    end
  end
end
