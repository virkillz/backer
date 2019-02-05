defmodule Backer.Auth.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    Phoenix.Controller.redirect(conn, to: "/admin/login")
  end
end
