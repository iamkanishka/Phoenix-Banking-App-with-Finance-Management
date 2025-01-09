defmodule PhoenixBankingAppWeb.HomeLive.Components.TotalBalanceBox do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <section class="total-balance flex flex-row gap-10">
      <div class="total-balance-chart">
        <div
          id="chart-container"
          phx-hook="DonutChart"
          data-chart-data={@chat_data}
        >
          <canvas id="donutChart" width="150" height="150"></canvas>
        </div>
      </div>

      <div class="flex flex-col gap-6 ms-16">
        <h2 class="header-2">
          Bank Accounts: {@total_banks}
        </h2>

        <div class="flex flex-col gap-2">
          <p class="total-balance-label">
            Total Current Balance
          </p>

          <div class="total-balance-amount flex-center gap-2">
            <div>
              <span>${@total_current_balance}</span>
            </div>
             <%!-- <AnimatedCounter amount={totalCurrentBalance} /> --%>
          </div>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
     {:ok,
     socket
     |> assign(assigns)
     |> assign_chart_data_value(assigns.accounts)}
  end

  def assign_chart_data_value(socket, accounts) do

    account_names = Enum.map(accounts, & &1.name)
    balances = Enum.map(accounts, &to_string(&1.current_balance))
    chart_data = %{
      labels: account_names,
      values: balances,
      colors: ["#36A2EB", "#FFCE56", "#FF9F40", "#4BC0C0", "#9966FF", "#FF6384", ] # Add or customize colors as needed
    }
    assign(socket, :chat_data, Jason.encode!(chart_data))
  end
end
