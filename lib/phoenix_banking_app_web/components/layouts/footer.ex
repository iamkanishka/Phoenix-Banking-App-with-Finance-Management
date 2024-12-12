defmodule PhoenixBankingAppWeb.Layouts.Footer do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="footer">
      Footer
    </footer>
    """
  end
end
