defmodule PhoenixBankingAppWeb.CustomComponents.HeaderBoxLive do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="header-box">
      <h1 class="header-box-title">
        {@title}
        <%= if @type == "greeting" do %>
          <span class="text-bankGradient">
            &nbsp;{@user}
          </span>
        <% end %>
      </h1>

      <p class="header-box-subtext">{@subtext}</p>
    </div>
    """
  end
end
