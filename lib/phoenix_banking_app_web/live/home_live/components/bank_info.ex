defmodule PhoenixBankingAppWeb.HomeLive.Components.BankInfo do
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Constants.AccountColors

  @impl true
  def render(assigns) do
    ~H"""
    <div
      phx-click="bank_transaction_history cursor-pointer"
      phx-target={@myself}
      class={"bank-info #{@colors["bg"]}" <> if  @type == "card" and   @appwrite_item_id ==  @account[:appwrite_item_id], do: "bg-bank-gradient", else: if @type == "card", do: "rounded-xl hover:shadow-sm cursor-pointer" ,else: "" }
    >
      <figure class={"flex-center h-fit rounded-full bg-blue-100 #{@colors["lightBg"]}"}>
        <img
          src="/images/connect-bank.svg"
          width={20}
          height={20}
          alt={@account[:sub_type]}
          class="m-2 min-w-5"
        />
      </figure>

      <div class="flex w-full flex-1 flex-col justify-center gap-1">
        <div class="bank-info_content">
          <h2 class={"text-16 line-clamp-1 flex-1 font-bold text-blue-900 #{@colors["title"]}"}>
            {@account[:name]}
          </h2>

          <%= if  @type == "full" do %>
            <p class={"text-12 rounded-full px-3 py-1 font-medium text-blue-700 #{@colors["subText"]} #{@colors["lightBg"]}"}>
              {@account[:sub_type]}
            </p>
          <% end %>
        </div>

        <p class={"text-16 font-medium text-blue-700 #{@colors["subText"]}"}>
          {format_amount(@account[:current_balance])}
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    colors = AccountColors.get_account_type_colors(assigns.account["type"])

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:colors, colors)}
  end

  @impl true
  def handle_event("bank_transaction_history", _unsigned_params, socket) do
    {:noreply,
     socket
     |> push_navigate(
       to:
         ~p"/transaction-history/#{socket.assigns.key}?id=#{to_string(socket.assigns.appwrite_item_id)}",
       replce: true
     )}
  end

  defp format_amount(amount) when is_number(amount) do
    Number.Currency.number_to_currency(amount, unit: "$", precision: 2)
  end
end
