defmodule ClarxApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ClarxApiWeb.Telemetry,
      # Start the Ecto repository
      ClarxApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ClarxApi.PubSub},
      # Start Finch
      {Finch, name: ClarxApi.Finch},
      # Start the Endpoint (http/https)
      ClarxApiWeb.Endpoint
      # Start a worker by calling: ClarxApi.Worker.start_link(arg)
      # {ClarxApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClarxApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClarxApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
