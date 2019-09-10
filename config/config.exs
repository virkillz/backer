# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backer,
  ecto_repos: [Backer.Repo]

# Configures the endpoint
config :backer, BackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U6rb9AJCDoSe1LtiNJOsLGzUW8+S60TApNALK1lnjems+w+yx3pcMD2d4dskTxax",
  render_errors: [view: BackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :backer, Backer.Auth.Guardian,
  issuer: "backer",
  secret_key: "HNinpKh9Ne3tr8BpjCpAEh0xzCqTIG3PWsfkR2AtzvUaRIpbs6oIQ9RcmjmGPekJ"

config :backer, Backer.Auth.AuthAccessPipeline,
  module: Backer.Auth.Guardian,
  error_handler: Backer.Auth.AuthErrorHandler

config :scrivener_html,
  routes_helper: BackerWeb.Router.Helpers

config :cloudex,
  api_key: "833245838569613",
  secret: "iKEo1f8h7Y2wxT1mptdcB7nFHjY",
  cloud_name: "backer"

config :phoenix, :template_engines, drab: Drab.Live.Engine

config :phoenix, :json_library, Jason

config :drab, BackerWeb.Endpoint,
  otp_app: :backer,
  js_socket_constructor: "window.__socket"

config :drab, BackerWeb.Endpoint, access_session: :current_backer_id

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
