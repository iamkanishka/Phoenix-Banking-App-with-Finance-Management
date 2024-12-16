defmodule PhoenixBankingAppWeb.Router do
  use PhoenixBankingAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixBankingAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug PhoenixBankingAppWeb.Plugs.CurrentUrlLiveView
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixBankingAppWeb do
    pipe_through :browser

    # auth routes
    live "/auth/sign-in", Auth.SignIn, :sign_in
    live "/auth/sign-up", Auth.SignUp, :sign_up

    # module routes
    live "/", Home.Show, :show
    live "/my-banks", MyBanks.Show, :show
    live "/payment-transfer", PaymentTransfer.Show, :show
    live "/transaction-history", TransactionHistory.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixBankingAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_banking_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixBankingAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
