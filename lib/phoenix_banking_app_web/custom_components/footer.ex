defmodule PhoenixBankingAppWeb.CustomComponents.Footer do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="footer">
      <div class={"" <> if @type == "mobile", do: "footer_name-mobile", else: "footer_name"}>
        <p class="text-xl font-bold text-gray-700">
          <%!-- {user?.firstName[0]} --%> K
        </p>
      </div>

      <div class={"" <> if @type == "mobile", do: "footer_email-mobile", else: "footer_email"}>
        <h1 class="text-14 truncate text-gray-700 font-semibold">
          <%!-- {user?.firstName} --%>
         Kanishka
        </h1>

        <p class="text-14 truncate font-normal text-gray-600">
          <%!-- {user?.email} --%>
          kansihkabc1123@gmail.com
        </p>
      </div>

      <div class="footer_image" phx-click="handle_log_out">
        <img src="/images/logout.svg" alt="logout" />
      </div>
    </footer>
    """
  end

  @impl true
  def handle_event("handle_log_out", _unsigned_params, socket) do
    {:noreply, socket}
  end
end
