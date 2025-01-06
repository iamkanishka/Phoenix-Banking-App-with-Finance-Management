defmodule PhoenixBankingApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias PhoenixBankingApp.Utils.SessionManager

  use Application

  @impl true
  def start(_type, _args) do
    SessionManager.init()

    children = [
      PhoenixBankingAppWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:phoenix_banking_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixBankingApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixBankingApp.Finch},
      # Start a worker by calling: PhoenixBankingApp.Worker.start_link(arg)
      # {PhoenixBankingApp.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixBankingAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixBankingApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixBankingAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
