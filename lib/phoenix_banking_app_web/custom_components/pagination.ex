defmodule PhoenixBankingAppWeb.CustomComponents.Pagination do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-between gap-3">
      <.button
        size="lg"
        variant="ghost"
        class="p-0 hover:bg-transparent"
        phx-click="prev"
        phx-target={@myself}
        disabled={@page <= 1}
      >
        <img src="/images/arrow-left.svg" alt="arrow" width={20} height={20} class="mr-2" /> Prev
      </.button>

      <p class="text-14 flex items-center px-2">
        {@page} / {@total_pages}
      </p>

      <.button
        size="lg"
        variant="ghost"
        class="p-0 hover:bg-transparent"
        phx-click="next"
        phx-target={@myself}
        disabled={@page >= @total_pages}
      >
        Next
        <img
          src="/images/arrow-left.svg"
          alt="arrow"
          width={20}
          height={20}
          class="ml-2 -scale-x-100"
        />
      </.button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("prev", _unsigned_params, socket) do
     pageNumber = String.to_integer(socket.assigns.page) - 1;
    {:noreply,
     socket
     |> push_patch(to: ~p"/?page=#{pageNumber}")}
  end

  @impl true
  def handle_event("next", _unsigned_params, socket) do
     pageNumber =  String.to_integer(socket.assigns.page) + 1;
    {:noreply,
     socket
     |> push_patch(to: ~p"/?page=#{pageNumber}")}
  end




end
