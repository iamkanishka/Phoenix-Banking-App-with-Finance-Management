defmodule PhoenixBankingAppWeb.HomeLive.Components.RightsideBar do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <aside class="right-sidebar">
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
                id={"bank_card#{Enum.at(@banks, 0)["$id"]}"}
                appwrite_item_id={@appwrite_item_id}
                account={Enum.at(@banks, 0)}
                userName={"#{@user.firstName} #{@user.lastName}"}
                showBalance={false}
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
                  id={"bank_card#{Enum.at(@banks, 1)["$id"]}"}
                  appwrite_item_id={@appwrite_item_id}
                  account={Enum.at(@banks, 1)}
                  userName={"#{@user.firstName} #{@user.lastName}"}
                  showBalance={false}
                />
              </div>
            <% end %>
          </div>
        <% end %>

        <div class="mt-10 flex flex-1 flex-col gap-6">
          <h2 class="header-2">Top categories</h2>

          <div class="space-y-5">
            <%= for category  <- @categories do %>
              <div>
                <.live_component
                  module={PhoenixBankingAppWeb.HomeLive.Components.Category}
                  id={:bank_category}
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
     |> assign(:categories, [])

     |> assign(assigns)}
  end
end
