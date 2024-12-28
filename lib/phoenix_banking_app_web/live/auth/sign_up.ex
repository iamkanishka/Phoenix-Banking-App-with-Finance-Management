defmodule PhoenixBankingAppWeb.Auth.SignUp do
  use PhoenixBankingAppWeb, :live_view

  alias PhoenixBankingApp.Dwolla.Customer
  alias PhoenixBankingApp.Plaid.Item
  alias PhoenixBankingApp.Plaid.Accounts


  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex-center size-full max-sm:px-6">
      <.live_component
        module={PhoenixBankingAppWeb.Auth.Components.AuthFormLive}
        id="{:authform}"
        type="sign-up"
      />
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("plaid_success", %{"public_token" => public_token}, socket) do
    IO.inspect(public_token, label: "Public Token")

    case exchange_public_token(public_token) do
      {:ok, result} ->
        IO.inspect(result, label: "exchange_public_token_res")
        {:noreply, socket |> push_patch(to: ~p"/")}

      {:error, reason} ->
        IO.inspect(reason, label: "Exchange Public Token Error")
        {:noreply, socket}
    end
  end

  defp exchange_public_token(public_token) do
    try do
      # user = socket.assigns.user

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

      {:ok, funding_source_response} =
        Customer.create_funding_source(
          "SBKXQ1yfOCYY4uluMd2mikOqghgSw7sg7Dz6EyGIKDvl1U8Dxv",
          "073b22f1-da56-45a0-a686-9737b4ff271b",
          %{
            name: account_data.name,
            plaidToken: processor_token_create_response[:processor_token]
          }
        )

      IO.inspect(funding_source_response, label: "funding_source_response")

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
