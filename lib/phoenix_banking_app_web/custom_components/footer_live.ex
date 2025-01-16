defmodule PhoenixBankingAppWeb.CustomComponents.FooterLive do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="footer">
      <div class={"" <> if @type == "mobile", do: "footer_name-mobile", else: "footer_name"}>
        <p class="text-xl font-bold text-gray-700">
          {capitalize_first_letter(@user["first_name"])}
        </p>
      </div>

      <div class={"" <> if @type == "mobile", do: "footer_email-mobile", else: "footer_email"}>
        <h1 class="text-14 truncate text-gray-700 font-semibold">
      {"#{@user["first_name"]} #{@user["last_name"]}"}
        </h1>

        <p class="text-14 truncate font-normal text-gray-600">

          { String.slice("#{@user["email"]}", 0, 20)}...
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

  def capitalize_first_letter(string) when is_binary(string) do
    String.slice(string, 0, 1)
    |> String.upcase()
  end
end
