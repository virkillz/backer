# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backer,
  ecto_repos: [Backer.Repo]

config :backer, env: Mix.env()

config :backer, BackerWeb.Gettext, default_locale: "id", locales: ~w(en id)

# Configures the endpoint
config :backer, BackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U6rb9AJCDoSe1LtiNJOsLGzUW8+S60TApNALK1lnjems+w+yx3pcMD2d4dskTxax",
  render_errors: [view: BackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Backer.PubSub

config :backer, BackerWeb.Endpoint,
  live_view: [
    signing_salt: "pcn+irkQjXqR3dNKr5IsDyPzv4ywu4pN"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# This will update new active status every month. But currently run every midnight for good measure.
config :backer, Backer.CronScheduler,
  jobs: [
    update_backer_aggregate: [
      schedule: "@midnight",
      task: {Backer.Aggregate, :update_backer_aggregate_batch, []}
    ],
    update_active_backer_count: [
      schedule: "@midnight",
      task: {Backer.Account, :update_donee_backer_count_batch, []}
    ]
  ]

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

config :imgex,
  imgix_domain: "https://backer.imgix.net",
  secure_token: "3355q2QZupnmhBR9"

config :sendgrid,
  api_key: "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"

config :ex_aws,
  # run source .env in root if this part got issues
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  s3: [
    scheme: "https://",
    host: "vkbacker.s3.amazonaws.com",
    region: "ap-southeast-1"
  ]

config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
