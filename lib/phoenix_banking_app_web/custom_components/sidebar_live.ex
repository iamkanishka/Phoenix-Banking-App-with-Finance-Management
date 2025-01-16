defmodule PhoenixBankingAppWeb.CustomComponents.SidebarLive do
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Constants.SidebarLinks

  @impl true
  def render(assigns) do
    ~H"""
    <section class="sidebar">
      <nav class="flex flex-col gap-4">
        <.link navigate={~p"/#{@key}"} class="mb-12 cursor-pointer flex items-center gap-2">
          <img
            src="/images/applogophxbank.png"
            alt="Horizon logo"
            width="64"
            class="size-[24px] max-xl:size-14"
            height="64"
          />
          <h1 class="sidebar-logo">Horizon</h1>
        </.link>

        <%= for %{label: label, imgURL: img_url, route: route}  <- SidebarLinks.get_sidebar_links() do %>
          <% is_active = @current_url == route %>
          <.link
            navigate={"#{route}#{@key}"}
            class={"sidebar-link " <> if is_active, do: "bg-bank-gradient", else: ""}
          >
            <div class="relative size-6">
              <img
                src={img_url}
                alt={label}
                class={"" <> if is_active, do: "brightness-[3] invert-0", else: ""}
              />
            </div>

            <p class={"sidebar-label " <> if is_active, do: "!text-white", else: ""}>
              {label}
            </p>
          </.link>
        <% end %>
      </nav>

      <%= if !@is_loading do %>
        <.live_component
          module={PhoenixBankingAppWeb.CustomComponents.FooterLive}
          id="{:footer}"
          type="desktop"
          user={@user}
        />
      <% end %>
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
