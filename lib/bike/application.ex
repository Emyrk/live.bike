defmodule Bike.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bike.Repo,
      # Start the Telemetry supervisor
      BikeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bike.PubSub},
      # Start the Endpoint (http/https)
      BikeWeb.Endpoint,
      # Starts all required services for managing the Karoo data
      Bike.Karoo.Supervisor
      # Start a worker by calling: Bike.Worker.start_link(arg)
      # {Bike.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bike.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BikeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
