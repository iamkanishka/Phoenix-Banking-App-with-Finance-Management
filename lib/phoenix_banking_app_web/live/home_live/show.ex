defmodule PhoenixBankingAppWeb.HomeLive.Show do
  use PhoenixBankingAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    accounts = [
      %{
        "name" => "Plaid saving",
        "subtype" => "Saving",
        "currentBalance" => 12365,
        "appwrite_item_id" => 1235,
        "type" => :depository
      },
      %{
        "name" => "Plaid Deposits",
        "subtype" => "Deposits",
        "currentBalance" => 856_365,
        "appwrite_item_id" => 12_378_524,
        "type" => :credit
      }
    ]

    {:noreply,
     socket
     |> assign(:appwrite_item_id, get_id(params, accounts))
     |> assign(:accounts, accounts)
     |> assign(:transactions, sample_transactions())
     |> assign(:url, uri)}
  end

  def get_id(params, accounts) do
    case params do
      %{"id" => id} ->
        # Process the id as needed
        id

      %{} ->
        # Handle the absence of the "id" parameter
        # For example, assign a default value or redirect
        Enum.at(accounts, 0)["appwrite_item_id"]
    end
  end

  def sample_transactions do
    [
      %{
        id: 1,
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: 2,
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: 3,
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: 4,
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: 5,
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      }
    ]
  end
end
