defmodule PhoenixBankingAppWeb.CustomComponents.Loader do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-full  relative">
      <!-- Wave Effect -->
      <div class="absolute rounded-full h-24 w-24 bg-blue-400 opacity-30 animate-ping"></div>

      <div class="absolute rounded-full h-32 w-32 bg-blue-300 opacity-20 animate-ping delay-150">
      </div>

    <!-- Image -->
      <div class="text-center z-10">
        <img src="/images/applogophxbank.png" alt="Phoenix Icon" class="w-16 h-16 mx-auto" />
        <p class="text-gray-600 text-sm mt-2">Loading Account Details...</p>
      </div>
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
