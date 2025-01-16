defmodule PhoenixBankingAppWeb.PaymentTransferLive.Show do
  alias PhoenixBankingApp.Services.BankService
  alias PhoenixBankingApp.Services.AuthService

  use PhoenixBankingAppWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    send(self(), {:load_critical_data, params})

    {:ok,
     socket
     |> assign(:accounts_data, [])
     |> assign(:key, params["key"])
     |> assign(:current_url, "/payment-transfer/")
     |> assign(:logged_in, %{})
     |> assign(:is_loading, true)}
  end

  @impl true
  def handle_params(unsigned_params, _uri, socket) do
    IO.inspect(unsigned_params, label: "unsigned_params")

    {:noreply, socket}
  end

  def get_user_data(params) do
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
  def get_accounts_data(user_id) do
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

    {:noreply,
     socket
     |> assign(:accounts_data, accounts[:data])
     |> assign(:logged_in, Enum.at(user_details["documents"], 0))
     |> assign(:is_loading, false)}
  end
end
