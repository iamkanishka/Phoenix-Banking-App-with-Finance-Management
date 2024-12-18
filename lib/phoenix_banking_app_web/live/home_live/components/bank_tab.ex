defmodule PhoenixBankingAppWeb.HomeLive.Components.BankTab do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="text-sm font-medium text-center text-gray-500 dark:text-gray-400 dark:border-gray-700">
        <ul class="flex flex-wrap -mb-px">
          <%= for account <- @accounts do %>
            <li class="me-2">
              <a
                href="#"
                phx-click="bank_change"
                phx-value-id={account["appwrite_item_id"]}
                phx-target={@myself}
                class={"inline-block p-4 border-b-2 rounded-t-lg " <>
          if String.to_integer(to_string(@appwrite_item_id)) == String.to_integer(to_string(account["appwrite_item_id"])) do
            "text-blue-600 border-blue-600 dark:text-blue-500 dark:border-blue-500"

          else
            "border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300"

          end}
              >
                {account["name"]}
              </a>
            </li>
          <% end %>
        </ul>
      </div>
       <%!-- Bank Info --%>
      <div>
        <%= for account <- @accounts do %>
          <%= if String.to_integer(to_string(@appwrite_item_id)) == String.to_integer(to_string(account["appwrite_item_id"])) do %>
            <.live_component
              module={PhoenixBankingAppWeb.HomeLive.Components.BankInfo}
              id={account["name"]}
              appwrite_item_id={@appwrite_item_id}
              url={@url}
              type="full"
              account={account}
            />
          <% end %>
        <% end %>
      </div>
       <%!-- Bank Transaction --%>
      <div>
        <.live_component
          module={PhoenixBankingAppWeb.CustomComponents.TransactionTable}
          id={:bank_transaction_table}
          transactions={@transactions}
        />
      </div>
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
  def handle_event("bank_change", %{"id" => id}, socket) do
    {:noreply,
     socket
     |> push_patch(to: ~p"/?id=#{id}")}
  end
end
