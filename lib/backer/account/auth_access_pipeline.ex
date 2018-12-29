defmodule Backer.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :backer

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end