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
        "appwrite_item_id" => 12378524,
        "type" => :credit
      }
    ]


  {:noreply,
     socket
     |> assign(:appwrite_item_id, get_id(params, accounts))
     |> assign(:accounts, accounts)
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
end
