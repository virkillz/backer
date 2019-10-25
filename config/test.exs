use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :backer, BackerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :backer, Backer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "indodax",
  password: "postgres",
  database: "backer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
