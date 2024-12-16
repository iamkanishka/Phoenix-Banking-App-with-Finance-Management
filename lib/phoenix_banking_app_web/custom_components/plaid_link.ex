defmodule PhoenixBankingAppWeb.CustomComponents.PlaidLink do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    if @variant == "primary",  do:
    <.button phx-click="open" disabled={!@ready} class="plaidlink-primary">
      Connect bank
    </.button>
    else:
    if @variant == "ghost",  do:
    <.button phx-click="open" @variant="ghost" class="plaidlink-ghost">
      <img src="/images/connect-bank.svg" alt="connect bank" width={24} height={24} />
      <p class="hiddenl text-[16px] font-semibold text-black-2 xl:block">Connect bank</p>
    </.button>
    else:
    <.button phx-click="open" class="plaidlink-default">
      <img src="/images/connect-bank.svg" alt="connect bank" width={24} height={24} />
      <p class="text-[16px] font-semibold text-black-2">Connect bank</p>
    </.button>
    end

    end
    """
  end

  @impl true
  def handle_event("open", _unsigned_params, socket) do
    {:noreply, socket}
  end
end
