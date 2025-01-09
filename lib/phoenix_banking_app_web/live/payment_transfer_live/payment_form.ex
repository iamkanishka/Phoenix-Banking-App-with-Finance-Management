defmodule PhoenixBankingAppWeb.PaymentTransferLive.PaymentForm do
  alias PhoenixBankingApp.Services.TransactionService
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Dwolla.Token
  alias PhoenixBankingApp.Dwolla.Dwolla
  alias PhoenixBankingApp.Services.BankService

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-full bg-white p-6 rounded-lg ">
      <h2 class="text-lg font-semibold mb-4">Payment Transfer</h2>

      <p class="text-sm text-gray-600 mb-3">
        Please provide any specific details or notes related to the payment transfer.
      </p>

      <.simple_form
        for={@form}
        as="transfer"
        phx-submit="send_payment"
        phx-change="validate"
        phx-target={@myself}
      >

    <!-- Select Source Bank -->
        <div class="mb-6">
          <div>
            <label class="block text-sm font-semibold leading-6 text-zinc-800" for="source-bank">
              Select Source Bank
            </label>

            <p class="text-sm text-gray-500 mb-2">
              Select the bank account you want to transfer funds from.
            </p>
          </div>

          <.input
            field={@form[:senderBank]}
            type="select"
            label=""
            placeholder="Select Source Bank"
            options={@bank_list}
          />
        </div>

    <!-- Transfer Note -->
        <div class="mb-6">
          <label class="block text-sm font-semibold leading-6 text-zinc-800" for="transfer-note">
            Transfer Note (Optional)
          </label>

          <p class="text-sm text-gray-500 mb-2">
            Please provide any additional information or instructions related to the transfer.
          </p>

          <.input
            field={@form[:name]}
            type="textarea"
            label=""
            placeholder="Transfer Note (Optional)"
          />
        </div>

    <!-- Bank Account Details Section -->
        <div class="mb-6">
          <h3 class="text-sm font-medium text-gray-700 mb-2">Bank account details</h3>

          <p class="text-sm text-gray-500 mb-4">
            Enter the bank account details of the recipient.
          </p>

    <!-- Recipient's Email Address -->
          <div class="mb-4">
            <label class="block text-sm font-semibold leading-6 text-zinc-800" for="recipient-email">
              Recipient's Email Address
            </label>
             <.input field={@form[:email]} type="email" label="" placeholder="user@mail.com" />
          </div>

    <!-- Receiver's Plaid Sharable ID -->
          <div class="mb-4">
            <label class="block text-sm font-semibold leading-6 text-zinc-800" for="plaid-id">
              Receiver's Plaid Sharable ID
            </label>

            <.input
              field={@form[:sharableId]}
              type="text"
              label=""
              placeholder="Enter the public account number"
            />
          </div>

    <!-- Amount -->
          <div class="mb-4">
            <label class="block text-sm font-semibold leading-6 text-zinc-800" for="amount">
              Amount
            </label>
             <.input field={@form[:amount]} type="number" label="" placeholder="5.00" />
          </div>
        </div>

    <!-- Submit Button -->
        <:actions>
          <.button
            class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
            phx-disable-with="Sending"
          >
            Transfer Fund
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do



    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()
     |> assign_bank_list()}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("send_payment", %{"form" => params}, socket) do
    IO.inspect(params)

    {:ok, transfer_and_transaction_res} = transfer_fund(socket, params)
    IO.inspect(transfer_and_transaction_res)

    if transfer_and_transaction_res[:trasaction_status] do
      {:noreply,
       socket
       |> put_flash(:info, "Transaction Successfull")
       |> push_navigate(to: "/#{transfer_and_transaction_res[:user_id]}", replace: true)}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Something went wrong ")}
    end

  end

  defp transfer_fund(socket, params) do
    try do
      dwolla_creds = %{
        client_id: Dwolla.get_client_id(),
        client_secret: Dwolla.get_client_secret()
      };

      {:ok, dwolla_token_details} = Token.get(dwolla_creds);

      {:ok, reciever_bank_data} = BankService.get_bank_by_account_id(params["sharableId"]);

      reciever_bank = Enum.at(reciever_bank_data["documents"], 0);


      bank_details = get_bank_details_by_name(params["senderBank"], socket);

      transfer_params = %{
        source_funding_source: Enum.at(bank_details,0)[:funding_source],
        destination_funding_source: reciever_bank["funding_source_id"],
        amount:  params["amount"]
      };

        IO.inspect(transfer_params, label: "transfer params")

      {:ok, tranfer_res} =
        BankService.create_transfer(dwolla_token_details.access_token, transfer_params);

      IO.inspect(tranfer_res);

      transaction_prams = %{
        name: params["name"],
        amount: params["amount"],
        sender_id: Enum.at(bank_details,0)[:user_id],
        sender_bank_id: Enum.at(bank_details,0)[:appwrite_item_id],
        reciever_id: reciever_bank["user_id"],
        reciever_bank_id: reciever_bank["$id"],
        email: params["email"],
        transaction_id:  tranfer_res[:id]
      };

      {:ok, transaction_res} = TransactionService.create_trasnsaction(transaction_prams);
      IO.inspect(transaction_res);
      {:ok, %{trasaction_status: true,  user_id: Enum.at(bank_details,0)[:user_id]}}
    catch
      {:error, error} ->
        {:ok, %{trasaction_status: false}}

        {:error, error}
    end
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end

  defp assign_bank_list(socket) do
    # IO.inspect(socket.assigns.accounts_data, label: "accounts_data")
    # IO.inspect(  label: "accounts_data end")
    banks_name_list = Enum.map(socket.assigns.accounts_data, fn item -> item[:display_name] end)
    assign(socket, :bank_list, banks_name_list)
  end

  defp get_bank_details_by_name(bank_name, socket) do
    Enum.filter(socket.assigns.accounts_data, fn item -> item[:display_name] == bank_name end)

  end
end
