defmodule PhoenixBankingAppWeb.Auth.SignUp do
  use PhoenixBankingAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex-center size-full max-sm:px-6">
      <.live_component
        module={PhoenixBankingAppWeb.Auth.Components.AuthFormLive}
        id="{:authform}"
        type="sign-up"
      />
    </section>
    """
  end
end
