defmodule PhoenixBankingAppWeb.CustomComponents.Pagination do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-between gap-3">
      <.button
        class="p-0 hover:bg-transparent"
        phx-click="prev"
        phx-target={@myself}
        disabled={@page <= 1}
      >
        <div class="flex">
          <img src="/images/arrow-left.svg" alt="arrow" width={20} height={20} class="mr-2" />
          <p>Prev</p>
        </div>
      </.button>

      <p class="text-14 flex items-center px-2">
        {@page} / {@total_pages}
      </p>

      <.button
        class="p-0 hover:bg-transparent"
        phx-click="next"
        phx-target={@myself}
        disabled={@page >= @total_pages}
      >
        <div class="flex">
          <p>Next</p>

          <img
            src="/images/arrow-left.svg"
            alt="arrow"
            width={20}
            height={20}
            class="ml-2 -scale-x-100"
          />
        </div>
      </.button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    page_number =
      if is_number(assigns.page), do: assigns.page, else: String.to_integer(assigns.page)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:page, page_number)}
  end

  @impl true
  def handle_event("prev", _unsigned_params, socket) do
    navigate_with_params(socket, "prev")
  end

  @impl true
  def handle_event("next", _unsigned_params, socket) do
    navigate_with_params(socket, "next")
  end

  defp navigate_with_params(socket, dir) do
    page = if dir == "next", do: socket.assigns.page + 1, else: socket.assigns.page - 1
    id = extract_id_from_url(socket.assigns.url)

    to =
      if id do
        ~p"/?id=#{id}&page=#{page}"
      else
        ~p"/?page=#{page}"
      end

    {:noreply,
     socket
     |> push_patch(to: to)}
  end

  # Helper function
  defp extract_id_from_url(url) do
    case URI.parse(url).query do
      nil -> nil
      query ->
        query
        |> URI.decode_query()
        |> Map.get("id")
    end
  end
end
