defmodule PhoenixBankingAppWeb.HomeLive.Components.RightsideBar do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <aside class="right-sidebar" style="700px !important">
      <section class="flex flex-col pb-8">
        <div class="profile-banner" />
        <div class="profile">
          <div class="profile-img">
            <%!-- <span class="text-5xl font-bold text-blue-500">{user.firstName[0]}</span> --%>
            <span class="text-5xl font-bold text-blue-500">K</span>
          </div>

          <div class="profile-details">
            <%!-- <h1 class='profile-name'>
              {user.firstName} {user.lastName}
            </h1>
            <p class="profile-email">
              {user.email}
            </p> --%>
            <h1 class="profile-name">
              Kanishka naik
            </h1>

            <p class="profile-email">
              Kanishkabc@gmail.com
            </p>
          </div>
        </div>
      </section>

      <section class="banks">
        <div class="flex w-full justify-between">
          <h2 class="header-2">My Banks</h2>

          <.link patch="~p/" class="flex gap-2">
            <img src="/images/plus.svg" width={20} height={20} alt="plus" />
            <h2 class="text-14 font-semibold text-gray-600">
              Add Bank
            </h2>
          </.link>
        </div>

        <%= if length(@banks) > 0 do %>
          <div class="relative flex flex-1 flex-col items-center justify-center gap-5">
            <div class="relative z-10">
              <%!-- <BankCard
                key={banks[0].$id}
                account={banks[0]}
                userName={`${user.firstName} ${user.lastName}`}
                showBalance={false}
              /> --%>
              <.live_component
                module={PhoenixBankingAppWeb.CustomComponents.BankCard}
                id={"bank_card#{:os.system_time(:millisecond)}"}
                appwrite_item_id={@appwrite_item_id}
                account={Enum.at(@banks, 0)}
                userName={"#{@user["first_name"]} #{@user["last_name"]}"}
                showBalance={false}
                key={@key}
              />
            </div>

            <%= if Enum.at(@banks, 1) do %>
              <div class="absolute right-0 top-8 z-0 w-[90%]">
                <%!-- <BankCard
                  key={banks[1].$id}
                  account={banks[1]}
                  userName={`${user.firstName} ${user.lastName}`}
                  showBalance={false}
                /> --%>
                <.live_component
                  module={PhoenixBankingAppWeb.CustomComponents.BankCard}
                  id={"bank_card#{:os.system_time(:millisecond)+100}"}
                  appwrite_item_id={@appwrite_item_id}
                  account={Enum.at(@banks, 1)}
                  userName={"#{@user["first_name"]} #{@user["last_name"]}"}
                  showBalance={false}
                  key={@key}
                />
              </div>
            <% end %>
          </div>
        <% end %>

        <div class="mt-10 flex flex-1 flex-col gap-6">
          <h2 class="header-2">Top categories</h2>

          <div class="space-y-5">
            <%= for {category, index} <- Enum.with_index(@categories)do %>
              <div>
                <.live_component
                  module={PhoenixBankingAppWeb.HomeLive.Components.Category}
                  id={"transaction-category#{index}"}
                  index
                  category={category}
                />
              </div>
            <% end %>
          </div>
        </div>
      </section>
    </aside>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:categories, count_transaction_categories(assigns.transactions))
     |> assign(assigns)}
  end

  def count_transaction_categories(transactions) do
    # Aggregate counts by category
    category_counts =
      Enum.reduce(transactions, %{}, fn transaction, acc ->
        category = Map.get(transaction, :category, "unknown")
        Map.update(acc, category, 1, &(&1 + 1))
      end)

    # Calculate the total count
    total_count = Enum.reduce(category_counts, 0, fn {_key, count}, acc -> acc + count end)

    # Convert to a list of maps and sort by count in descending order
    category_counts
    |> Enum.map(fn {category, count} ->
      %{name: category, count: count, total_count: total_count}
    end)
    |> Enum.sort_by(& &1.count, :desc)
  end
end
