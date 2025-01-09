defmodule PhoenixBankingAppWeb.MyBanksLive.Show do
  use PhoenixBankingAppWeb, :live_view
  alias PhoenixBankingApp.Services.BankService
  alias PhoenixBankingApp.Services.AuthService


  @impl true
  def mount(params, _session, socket) do
    {:ok, user_details} = get_user_data(params)
    user_id = Enum.at(user_details["documents"], 0)["user_id"]
    {:ok, accounts} = get_accounts_data(user_id)
    IO.inspect(accounts)

    {:ok,
     socket
     |> assign(:accounts_data, accounts[:data])
     |> assign(:logged_in, Enum.at(user_details["documents"], 0))
     |> assign(:current_url, "/my-banks")}
  end

  @impl true
   def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
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
end
