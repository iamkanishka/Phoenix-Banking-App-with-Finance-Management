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

    mod_url =
      if String.contains?(socket.assigns.url, "transaction-history"),
        do: "transaction-history/#{socket.assigns.key}",
        else: "#{socket.assigns.key}"

    to =
      if id do
        ~p"/#{mod_url}?id=#{id}&page=#{page}"
      else
        ~p"/#{mod_url}?page=#{page}"
      end

    {:noreply,
     socket
     |> push_patch(to: String.replace(to, "%2F", "/"))}
  end

  # Helper function
  defp extract_id_from_url(url) do
    case URI.parse(url).query do
      nil ->
        nil

      query ->
        query
        |> URI.decode_query()
        |> Map.get("id")
    end
  end

  def paginate(transactions, page, rows_per_page \\ 10) do
    pageNumber = if is_number(page), do: page, else: String.to_integer(page)

    total_pages = div(Enum.count(transactions) + rows_per_page - 1, rows_per_page)

    index_of_last_transaction = pageNumber * rows_per_page
    index_of_first_transaction = index_of_last_transaction - rows_per_page

    current_transactions = Enum.slice(transactions, index_of_first_transaction, rows_per_page)

    %{total_pages: total_pages, current_transactions: current_transactions}
  end
end
