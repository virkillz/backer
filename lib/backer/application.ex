defmodule Backer.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Backer.Repo, []),
      {Phoenix.PubSub, name: Backer.PubSub},
      # Start the endpoint when the application starts
      supervisor(BackerWeb.Endpoint, []),
      worker(Backer.HourlyScheduler, []),
      worker(CUID, [CUID]),
      worker(Cachex, [:notification, []], id: :cachex_1),
      worker(Backer.CronScheduler, []),
      worker(Task, [&CacheWarmer.warm/0], restart: :temporary)
      # Start your own worker by calling: Backer.Worker.start_link(arg1, arg2, arg3)
      # worker(Backer.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Backer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
