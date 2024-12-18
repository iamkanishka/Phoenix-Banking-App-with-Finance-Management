defmodule PhoenixBankingAppWeb.HomeLive.Components.BankInfo do
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Constants.AccountColors

  @impl true
  def render(assigns) do
    ~H"""
    <div
      phx-click="bank_change"
      phx-target={@myself}
      class={"bank-info #{@colors["bg"]}" <> if  @type == "card" and  String.to_integer(to_string(@appwrite_item_id)) == String.to_integer(to_string(@account["appwrite_item_id"])), do: "bg-bank-gradient", else: if @type == "card", do: "rounded-xl hover:shadow-sm cursor-pointer" ,else: "" }
    >
      <figure class={"flex-center h-fit rounded-full bg-blue-100 #{@colors["lightBg"]}"}>
        <img
          src="/images/connect-bank.svg"
          width={20}
          height={20}
          alt={@account["subtype"]}
          class="m-2 min-w-5"
        />
      </figure>

      <div class="flex w-full flex-1 flex-col justify-center gap-1">
        <div class="bank-info_content">
          <h2 class={"text-16 line-clamp-1 flex-1 font-bold text-blue-900 #{@colors["title"]}"}>
            {@account["name"]}
          </h2>

          <%= if  @type == "full" do %>
            <p class={"text-12 rounded-full px-3 py-1 font-medium text-blue-700 #{@colors["subText"]} #{@colors["lightBg"]}"}>
              {@account["subtype"]}
            </p>
          <% end %>
        </div>

        <p class={"text-16 font-medium text-blue-700 #{@colors["subText"]}"}>
          {format_amount(@account["currentBalance"])}
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
  def handle_event("bank_change", _unsigned_params, socket) do
    {:noreply,
     socket
     |> push_patch(to: ~p"/?id=#{to_string(socket.assigns.appwrite_item_id)}")}
  end

  defp format_amount(amount) when is_number(amount) do
    Number.Currency.number_to_currency(amount, unit: "$", precision: 2)
  end
end
