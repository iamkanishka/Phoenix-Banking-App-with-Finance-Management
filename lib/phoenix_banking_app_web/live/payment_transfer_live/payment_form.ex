defmodule PhoenixBankingAppWeb.PaymentTransferLive.PaymentForm do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} as="transfer" phx-submit="submit">
      <.input
        field={@form[:senderBank]}
        type="select"
        label="Select Source Bank"
        placeholder="Select Source Bank"
        options={["", "Male", "Female", "Others"]}
      />
      <.input
        field={@form[:name]}
        type="textarea"
        label="Transfer Note (Optional)"
        placeholder="Transfer Note (Optional)"
      />
      <div className="payment-transfer_form-details">
        <h2 className="text-18 font-semibold text-gray-900">
          Bank account details
        </h2>

        <p className="text-16 font-normal text-gray-600">
          Enter the bank account details of the recipient
        </p>
      </div>
       <.input field={@form[:email]} type="email" label="Recipient's Email Address" />
      <.input field={@form[:sharableId]} type="text" label="Receiver's Plaid Sharable ID" />
      <.input field={@form[:amount]} type="number" label="Amount" />
    </.simple_form>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:form, %{})
     |> assign(assigns)}
  end
end
