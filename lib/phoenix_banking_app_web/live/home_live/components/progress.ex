defmodule PhoenixBankingAppWeb.HomeLive.Components.Progress do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class={"relative h-4 w-full overflow-hidden rounded-full bg-secondary #{assigns.class}"}>
      <div
        class={"h-full w-full flex-1 bg-primary transition-all #{assigns.indicator_class}"}
        style={"transform: translateX(-#{100 - (@value || 0)}%);"}
      />
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
