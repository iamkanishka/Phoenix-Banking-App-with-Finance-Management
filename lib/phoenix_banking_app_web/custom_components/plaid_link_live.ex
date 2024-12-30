defmodule PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive do
  alias PhoenixBankingApp.Plaid.Link

  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <section class="auth-form">
      <header class="flex flex-col gap-5 md:gap-8">
        <.link navigate={~p"/"} class="cursor-pointer flex items-center gap-1">
          <img src="/images/logo.svg" width={34} height={34} alt="Horizon logo" />
          <h1 class="text-26 font-ibm-plex-serif font-bold text-black-1">Horizon</h1>
        </.link>

        <div class="flex flex-col gap-1 md:gap-3">
          <h1 class="text-24 lg:text-36 font-semibold text-gray-900">
            Link Account
            <p class="text-16 font-normal text-gray-600">
              Link your account to get started
            </p>
          </h1>
        </div>
      </header>

      <div>
        <%= if @variant == "primary" do %>
          <.button
            id="plaid-link-button"
            phx-hook="PlaidConnect"
            data-link-token={@link_token}
            phx-target={@myself}
            class={"" <> if !@ready and @link_token != nil, do: "plaidlink-primary", else: "plaidlink-ghost"}
            disabled={@ready and @link_token == nil}
          >
            <p>
              {"" <>
                if !@ready and @link_token != nil and @loader,
                  do: "Connecting...",
                  else: "Connect bank"}
            </p>
          </.button>
        <% end %>

        <%!-- <% else %>
        <%= if @variant == "ghost" do %>
          <.button phx-click="open" class="plaidlink-ghost">
            <img src="/images/connect-bank.svg" alt="connect bank" width={24} height={24} />
            <p class="hiddenl text-[16px] font-semibold text-black-2 xl:block">Connect bank</p>
          </.button>
        <% else %>
          <.button phx-click="open" class="plaidlink-default">
            <img src="/images/connect-bank.svg" alt="connect bank" width={24} height={24} />
            <p class="text-[16px] font-semibold text-black-2">Connect bank</p>
          </.button>
        <% end %>
      <% end %> --%>
      </div>
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(:link_token, nil)
      |> assign(:ready, true)
      |> assign(assigns)
      |> generate_link_token()
    }
  end

  defp generate_link_token(socket) do
    try do
      user = socket.assigns.user

      params = %{
        client_name: "#{user["first_name"]} #{user["last_name"]}",
        language: "en",
        country_codes: ["US"],
        products: ["auth"],
        user: %{client_user_id: user["user_id"]}
      }

      # Use your backend logic to generate a link token
      {:ok, create_link_token_res} = Link.create_link_token(params)

      socket
      |> assign(:ready, false)
      |> assign(:link_token, create_link_token_res.link_token)
    catch
      {:error, error} ->
        socket
        |> assign(:ready, true)
        |> assign(:link_token, nil)

        IO.inspect(error)
        raise error
    end
  end
end
