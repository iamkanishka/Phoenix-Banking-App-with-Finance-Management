defmodule PhoenixBankingApp.Utils.DateUtil do
  @doc """
  Initializes the start and end dates for the current month and year.
  """
  def initialize_dates do
    current_date = Date.utc_today()
    {year, month} = {current_date.year, current_date.month}

    start_date = %Date{year: year, month: month, day: 1}
    end_date = Date.end_of_month(start_date)

    {start_date, end_date}
  end

  @doc """
  Adjusts the month and year for "Load More" functionality.
  Moves forward by one month.
  """
  def adjust_dates(%Date{year: year, month: month} = _current_start_date) do
    new_month = if month == 12, do: 1, else: month + 1
    new_year = if month == 12, do: year + 1, else: year

    start_date = %Date{year: new_year, month: new_month, day: 1}
    end_date = Date.end_of_month(start_date)

    {start_date, end_date}
  end
end
