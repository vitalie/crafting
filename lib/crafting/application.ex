defmodule Crafting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CraftingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Crafting.PubSub},
      # Start the Endpoint (http/https)
      CraftingWeb.Endpoint
      # Start a worker by calling: Crafting.Worker.start_link(arg)
      # {Crafting.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crafting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CraftingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
