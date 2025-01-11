defmodule PhoenixBankingAppWeb.HomeLive.Show do
  use PhoenixBankingAppWeb, :live_view
  alias PhoenixBankingApp.Services.BankService
  alias PhoenixBankingApp.Services.AuthService

  @impl true
  def mount(params, _session, socket) do
    send(self(), {:load_critical_data, params})

    {:ok,
     socket
     |> assign(:key, params["key"])
     |> assign(:current_url, "/")
     |> assign(:accounts_data, [])
     |> assign(:total_current_balance, 0)
     |> assign(:total_banks, [])
     |> assign(:appwrite_item_id, "")
     |> assign(:logged_in, %{})
     |> assign(:is_loading, true)}
  end

  @impl true
  def handle_params(params, uri, socket) do
    {:noreply,
     socket
     |> assign(:page, get_page(params, 1))
     |> assign(:transactions, sample_transactions())
     |> assign(:url, uri)}
  end

  def get_id(params, accounts) do
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

  def sample_transactions do
    [
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase first ",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      }
    ]
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

  @impl true
  def handle_info({:load_critical_data, params}, socket) do
    {:ok, user_details} = get_user_data(params)
    user_id = Enum.at(user_details["documents"], 0)["user_id"]
    {:ok, accounts} = get_accounts_data(user_id)
    IO.inspect(accounts)

    {:noreply,
     socket
     |> assign(:accounts_data, accounts[:data])
     |> assign(:total_current_balance, accounts[:total_current_balance])
     |> assign(:total_banks, accounts[:total_banks])
     |> assign(:appwrite_item_id, get_id(params, accounts[:data]))
     |> assign(:logged_in, Enum.at(user_details["documents"], 0))
     |> assign(:is_loading, false)}
  end
end
