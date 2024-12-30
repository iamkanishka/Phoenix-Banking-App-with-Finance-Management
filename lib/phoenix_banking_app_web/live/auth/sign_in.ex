defmodule PhoenixBankingAppWeb.Auth.SignIn do
  alias PhoenixBankingAppWeb.Auth.Services.AuthService
  use PhoenixBankingAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex-center size-full max-sm:px-6">
      <%= if @user == nil  do %>
        <.live_component
          module={PhoenixBankingAppWeb.Auth.Components.AuthFormLive}
          id="{:authform}"
          type="sign-in"
        />
      <% end %>

      <%= if @user !=nil and @need_bank_connectivity do %>
        <div class="flex flex-col gap-4">
          <.live_component
            module={PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive}
            id={:plaidlink}
            user={@user}
            variant="primary"
            loader={@connect_bank_loader}
          />
        </div>
      <% end %>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:user, nil)
      |> assign_loader(false)
    }
  end

  @impl true
  def handle_event("plaid_success", %{"public_token" => public_token}, socket) do
    IO.inspect(public_token, label: "Public Token")
    assign_loader(socket, true)

    case AuthService.exchange_public_token(public_token, socket) do
      {:ok, result} ->
        IO.inspect(result, label: "exchange_public_token_res")

        {:noreply,
         socket
         |> assign_loader(false)
         |> push_navigate(to: "/", replace: true)}

      {:error, reason} ->
        IO.inspect(reason, label: "Exchange Public Token Error")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:user, user}, socket) do
    {:noreply,
     socket
     |> assign(:user, user)}
  end

  defp assign_loader(socket, loader_value) do
    assign(socket, :connect_bank_loader, loader_value)
  end
end
