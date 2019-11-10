defmodule BackerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backer

  socket("/socket", BackerWeb.UserSocket,
    websocket: true,
    check_origin: ["//localhost", "//*.backer.id", "//*.backr.id"]
  )

  socket "/live", Phoenix.LiveView.Socket,
    websocket: true,
    check_origin: ["//localhost", "//*.backer.id", "//*.backr.id"]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :backer,
    gzip: false,
    only_matching: ~w(css img fonts assets images front app-assets js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(Plug.Session,
    store: :cookie,
    key: "_backer_key",
    signing_salt: "23VfcC7o"
  )

  plug CORSPlug,
    origin: [
      "http://localhost:3000",
      "http://alpha.backer.id",
      "http://alpha.backr.id",
      "http://localhost:4000"
    ],
    allow_headers: ["accept", "content-type", "authorization"],
    allow_credentials: true,
    log: [rejected: :error, invalid: :warn, accepted: :debug]

  plug(BackerWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
