defmodule Backer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :backer,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Backer.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :timex,
        :scrivener_ecto,
        :scrivener_html,
        :timex
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.15.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"},
      {:secure_random, "~> 0.5"},
      {:guardian, "~> 1.0"},
      {:comeonin, "~> 5.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:timex, "~> 3.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:scrivener_html, git: "https://github.com/virkonomy/scrivener_html.git", tag: "v1.8.2"},
      {:earmark, "~> 1.3"},
      {:cloudex, "~> 1.4.0"},
      {:number, "~> 1.0"},
      {:html_sanitize_ex, "~> 1.3"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:imgex, "~> 0.2.0"},
      {:cors_plug, "~> 2.0"},
      {:sendgrid, "~> 2.0"},
      {:cachex, "~> 3.2"},
      {:quantum, "~> 2.3"},
      {:httpoison, "~> 1.8"},
      {:floki, ">= 0.0.0", only: :test},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:absinthe, "~> 1.4.16"},
      {:absinthe_ecto, "~> 0.1.3"},
      {:absinthe_plug, "~> 1.4.7"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
