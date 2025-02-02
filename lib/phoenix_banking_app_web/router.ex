defmodule PhoenixBankingAppWeb.Router do
  use PhoenixBankingAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixBankingAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated_browser do
    plug PhoenixBankingAppWeb.Plugs.SessionValidator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixBankingAppWeb do
    pipe_through :browser

    # auth routes
    live "/auth/sign-in", Auth.SignIn, :sign_in
    live "/auth/sign-up", Auth.SignUp, :sign_up
  end

  scope "/", PhoenixBankingAppWeb do
    pipe_through [:browser, :authenticated_browser]

    # module routes
    live "/:key", HomeLive.Show, :show
    live "/my-banks/:key", MyBanksLive.Show, :show
    live "/payment-transfer/:key", PaymentTransferLive.Show, :show
    live "/transaction-history/:key", TransactionHistoryLive.Show, :show
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
