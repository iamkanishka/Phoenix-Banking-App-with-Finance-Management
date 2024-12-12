defmodule PhoenixBankingAppWeb.Layouts.Sidebar do
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <section class="sidebar">
      <nav className="flex flex-col gap-4">
        <link href="/" className="mb-12 cursor-pointer flex items-center gap-2" />
        <img
          src="/images/app_logo.svg"
          alt="Horizon logo"
          width="34"
          class="size-[24px] max-xl:size-14"
          height="34"
        />
        <h1 class="sidebar-logo">Horizon</h1>
        />
      </nav>


       <.live_component module={PhoenixBankingAppWeb.Layouts.Footer} id="{:footer}" />
    </section>
    """
  end
end
