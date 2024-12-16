defmodule PhoenixBankingAppWeb.HomeLive.Components.RecentTransaction do
  use PhoenixBankingAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <section class="recent-transactions">
      <header class="flex items-center justify-between">
        <h2 class="recent-transactions-label">Recent transactions</h2>

        <.link navigate={"~p/transaction-history/?id=#{@appwriteItemId}"} class="view-all-btn">
          View all
        </.link>
      </header>
       <%!-- Tab Section --%>
      <%!-- <.live_component
        module={PhoenixBankingAppWeb.HomeLive.Components.TabsLive}
        id={:tabs}
        class="w-full"
      >
        <:slots>
          <.live_component
            module={PhoenixBankingAppWeb.HomeLive.Components.TabsList}
            id={:tabslist}
            class="recent-transactions-tablist"
          >
            <:slots>
              <.live_component
                module={PhoenixBankingAppWeb.HomeLive.Components.TabsTrigger}
                id={:tabstrigger}
                class="recent-transactions-tablist"
              >
              </.live_component>
            </:slots>
          </.live_component>
        </:slots>
      </.live_component> --%>
      <div class="text-sm font-medium text-center text-gray-500 dark:text-gray-400 dark:border-gray-700">
        <ul class="flex flex-wrap -mb-px">
          <li class="me-2">
            <a
              href="#"
              class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300"
            >
              Plaid Checking
            </a>
          </li>

          <li class="me-2">
            <a
              href="#"
              class="inline-block p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg active dark:text-blue-500 dark:border-blue-500"
              aria-current="page"
            >
              Plaid Saving
            </a>
          </li>
        </ul>
      </div>
    </section>
    """
  end
end
