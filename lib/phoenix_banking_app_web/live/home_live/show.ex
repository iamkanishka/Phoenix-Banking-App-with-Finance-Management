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
     |> assign(:page, get_page(params, 1))
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

  def get_page(params, default_page \\ 1) do
    case params do
      %{"page" => page} ->
        # Return the page value from params
        page

      %{} ->
        # Return the default page if "page" key is not present
        default_page
    end
  end

  def sample_transactions do
    [
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase first ",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase second",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption third",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store  gsgsgsgsgsg Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },

      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment   7238723465876234",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership sadchajsdghcvjhasdgc",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Grocery Store Purchase",
        amount: 75.50,
        type: "debit",
        date: "2024-12-10T14:30:00Z",
        payment_channel: "credit card",
        category: "Food and Drink"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Salary Payment",
        amount: 3000.00,
        type: "credit",
        date: "2024-12-01T09:00:00Z",
        payment_channel: "bank transfer",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Electric Bill Payment",
        amount: 120.75,
        type: "debit",
        date: "2024-12-15T10:00:00Z",
        payment_channel: "online banking",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gym Membership",
        amount: 50.00,
        type: "debit",
        date: "2024-11-25T16:00:00Z",
        payment_channel: "credit card",
        category: "Payment"
      },
      %{
        id: :erlang.unique_integer([:positive]),
        name: "Gift Card Redemption 6 cghecking ",
        amount: 25.00,
        type: "credit",
        date: "2024-12-05T11:45:00Z",
        payment_channel: "gift card",
        category: "Payment"
      }

    ]
  end
end
