defmodule PhoenixBankingAppWeb.HomeLive.Components.RecentTransaction do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <section class="recent-transactions">
      <header class="flex items-center justify-between">
        <h2 class="recent-transactions-label">Recent transactions</h2>

        <.link navigate={"~p/transaction-history/?id=#{@appwrite_item_id}"} class="view-all-btn">
          View all
        </.link>
      </header>
       <%!-- Tab Section --%>
      <.live_component
        module={PhoenixBankingAppWeb.HomeLive.Components.BankTab}
        id={:bank_tab}
        appwrite_item_id={@appwrite_item_id}
        url={@url}
        accounts={@accounts}
        transactions={@transactions}
        page={@page}
      />
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
