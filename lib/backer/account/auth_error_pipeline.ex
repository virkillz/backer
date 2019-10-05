defmodule Backer.Auth.AuthErrorHandler do
  @moduledoc false

  def auth_error(conn, {_type, _reason}, _opts) do
    Phoenix.Controller.redirect(conn, to: "/admin/login")
  end
end
