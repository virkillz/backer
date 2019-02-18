defmodule BackerWeb.Plugs.BackerNonSignCheck do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.backer_signed_in? do
      Phoenix.Controller.redirect(conn, to: "/home")
    else
      conn
    end
  end
end
