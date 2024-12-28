defmodule PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive do
  alias PhoenixBankingApp.Plaid.Link

  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @variant == "primary" do %>
        <.button
          id="plaid-link-button"
          phx-hook="PlaidConnect"
          data-link-token={@link_token}
          phx-target={@myself}
          class="plaidlink-primary"
        >
          Connect bank
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
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(:link_token, "link-sandbox-70812bd5-5ccb-4383-8f5d-f1a59cfb4741")
      |> assign(:ready, false)
      |> assign(assigns)
      # |> generate_link_token()
    }
  end

  defp generate_link_token(socket) do
    try do
      user = socket.assigns.user
      # params = %{
      #   client_name: "#{user[:first_name]} #{user[:last_name]}",
      #   language: "en",
      #   country_codes: "US",
      #   products: ["auth"],
      #   user: %{client_user_id: user[:user_id]}
      # }

      params = %{
        client_name: "Knaishka Naik",
        language: "en",
        country_codes: ["US"],
        products: ["auth"],
        user: %{client_user_id: "180f1a8450a94c5fafabcaf1979ff23d"}
      }

      # Use your backend logic to generate a link token
      {:ok, create_link_token_res} = Link.create_link_token(params)

      #     {:ok,
      #  %PhoenixBankingApp.Plaid.Link{
      #    link_token: "link-sandbox-70051614-ecee-4efc-87bb-be0ae0997728",
      #    expiration: "2024-12-28T04:44:31Z",
      #    request_id: "2TmrB0vOcZDwgYT",
      #    created_at: nil,
      #    metadata: nil
      #  }}

      IO.inspect(create_link_token_res)

      {:ok,
       socket
       |> assign(:link_token, create_link_token_res["link_token"])}
    catch
      {:error, error} ->
        IO.inspect(error)
        raise error
    end
  end
end
