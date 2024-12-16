defmodule PhoenixBankingAppWeb.CustomComponents.Sidebar do
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Constants.SidebarLinks

  @impl true
  def render(assigns) do
    ~H"""
    <section class="sidebar">
      <nav class="flex flex-col gap-4">
        <.link navigate={~p"/"} class="mb-12 cursor-pointer flex items-center gap-2">
          <img
            src="/images/app_logo.svg"
            alt="Horizon logo"
            width="34"
            class="size-[24px] max-xl:size-14"
            height="34"
          />
          <h1 class="sidebar-logo">Horizon</h1>
        </.link>

        <%= for %{label: label, imgURL: img_url, route: route}  <- SidebarLinks.get_sidebar_links() do %>
          <%!-- <% is_active = @current_path == link.route or String.starts_with?(@current_path, "#{link.route}/") %> --%> <% is_active =
            false %>
          <.link
            navigate={route}
            class={"sidebar-link" <> if is_active, do: "bg-bank-gradient", else: ""}
          >
            <div class="relative size-6">
              <img
                src={img_url}
                alt={label}
                class={"" <> if is_active, do: "brightness-[3] invert-0", else: ""}
              />
            </div>

            <p class={"sidebar-label" <> if is_active, do: "!text-white", else: ""}>
              {label}
            </p>
          </.link>
        <% end %>
      </nav>

      <.live_component
        module={PhoenixBankingAppWeb.CustomComponents.Footer}
        id="{:footer}"
        type="desktop"
      />
    </section>
    """
  end
end
