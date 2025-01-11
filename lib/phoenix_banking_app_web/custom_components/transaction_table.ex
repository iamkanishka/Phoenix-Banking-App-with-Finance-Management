defmodule PhoenixBankingAppWeb.CustomComponents.TransactionTable do
  alias Appwrite.Utils.General
  use PhoenixBankingAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.table id="transactions" rows={@transactions}>
        <:col :let={t} label="Transaction" class="max-w-[250px] pl-2 pr-10">
          <div class="flex items-center gap-3">
            <h1 class="text-14 truncate font-semibold text-[#344054]">
              {remove_special_characters(t.name)}
            </h1>
          </div>
        </:col>

        <:col :let={t} label="Amount" class="pl-2 pr-10 font-semibold">
          <span class={
            if t.type == "debit" || String.starts_with?(format_amount(t.amount), "-") do
              "text-[#f04438]"
            else
              "text-[#039855]"
            end
          }>
            {if t.type == "debit", do: "-" <> format_amount(t.amount), else: format_amount(t.amount)}
          </span>
        </:col>

        <:col :let={t} label="Status" class="pl-2 pr-10">
          <.live_component
            module={PhoenixBankingAppWeb.CustomComponents.CategoryBadge}
            id={"category_status_#{General.generate_uniqe_id()}"}
            category={get_transaction_status(t.date)}
          />
        </:col>

        <:col :let={t} label="Date" class="min-w-32 pl-2 pr-10">
          {format_date_time(t.date)}
        </:col>

        <:col :let={t} label="Channel" class="pl-2 pr-10 capitalize min-w-24 max-md:hidden">
          {t.payment_channel}
        </:col>

        <:col :let={t} label="Category" class="pl-2 pr-10 max-md:hidden">
          <.live_component
            module={PhoenixBankingAppWeb.CustomComponents.CategoryBadge}
            id={"category_badge_#{General.generate_uniqe_id()}"}
            category={t.category}
          />
        </:col>
      </.table>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:unique_id, System.unique_integer())
     |> assign(assigns)}
  end

  defp format_amount(amount) when is_number(amount) do
    Number.Currency.number_to_currency(amount, unit: "$", precision: 2)
  end

  # Formats a date to a readable format, e.g., "Dec 18, 2024".
  defp format_date_time(transaction_date) do
    t_date =
      if String.contains?(transaction_date, "T"),
        do: transaction_date,
        else: convert_date_to_native_time(transaction_date)

    {:ok, date} = Timex.parse(t_date, "{ISO:Extended}")

    Timex.format!(date, "{Mshort} {D}, {YYYY}")
  end

  defp get_transaction_status(transaction_date) do
    t_date =
      if String.contains?(transaction_date, "T"),
        do: transaction_date,
        else: convert_date_to_native_time(transaction_date)

    {:ok, date} = Timex.parse(t_date, "{ISO:Extended}")

    if Timex.before?(date, Timex.now()) do
      "Success"
    else
      "Processing"
    end
  end

  # Removes special characters from a string.
  defp remove_special_characters(string) do
    String.replace(string, ~r/[^a-zA-Z0-9\s]/, "")
  end

  defp convert_date_to_native_time(transaction_date) do
    {:ok, date} = Date.from_iso8601(transaction_date)

    # Convert the `Date` to a `NaiveDateTime` (time defaults to midnight)
    naive_datetime = NaiveDateTime.new!(date, ~T[00:00:00])

    # Convert the `NaiveDateTime` to a UTC `DateTime`
    datetime = DateTime.from_naive!(naive_datetime, "Etc/UTC")

    # Convert the `DateTime` to an ISO 8601 string
    DateTime.to_iso8601(datetime)
  end
end
