defmodule PhoenixBankingAppWeb.Auth.SignUp do
  alias PhoenixBankingApp.Services.AuthService
  use PhoenixBankingAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <main class="flex min-h-screen w-full justify-between font-inter">
      <section class="flex-center size-full max-sm:px-6">
        <%= if @user == nil do %>
          <.live_component
            module={PhoenixBankingAppWeb.Auth.Components.AuthFormLive}
            id="{:authform}"
            type="sign-up"
          />
        <% else %>
          <div class="flex flex-col gap-4">
            <.live_component
              module={PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive}
              id={:plaidlink}
              user={@user}
              variant="primary"
              status={@connect_bank_status}
            />
          </div>
        <% end %>
      </section>

      <div class="auth-asset">
        <div>
          <img
            src="/images/auth-image.svg"
            alt="Auth image"
            width={500}
            height={500}
            class="rounded-l-xl object-contain"
          />
        </div>
      </div>
    </main>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_loader(false)
     |> assign(:user, nil)}
  end

  @impl true
  def handle_event("plaid_success", %{"public_token" => public_token}, socket) do
    IO.inspect(public_token, label: "Public Token")
    socket = assign_loader(socket, true)
    IO.inspect(socket.assigns.connect_bank_status)

    case AuthService.exchange_public_token(public_token, socket) do
      {:ok, result} ->
        IO.inspect(result, label: "exchange_public_token_res")

        {:noreply,
         socket
         |> assign_loader(false)
         |> push_navigate(to: "/#{socket.assigns.user["session_key"]}", replace: true)}

      {:error, reason} ->
        IO.inspect(reason, label: "Exchange Public Token Error")

        {:noreply,
         socket
         |> assign_loader(false)}
    end
  end

  def handle_info({:user, user}, socket) do
    {:noreply,
     socket
     |> assign(:user, user)}
  end

  defp assign_loader(socket, status) do
    assign(socket, :connect_bank_status, status)
  end
end
