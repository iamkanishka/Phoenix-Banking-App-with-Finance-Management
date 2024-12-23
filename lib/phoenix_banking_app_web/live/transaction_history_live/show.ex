defmodule PhoenixBankingAppWeb.TransactionHistoryLive.Show do

  use PhoenixBankingAppWeb, :live_view

  @impl true
  def mount(params, session, socket) do
  {:ok, socket}
  end


  def format_amount(amount) when is_number(amount) do
    Number.Currency.number_to_currency(amount, unit: "$", precision: 2)
  end

end
