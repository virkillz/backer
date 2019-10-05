defmodule BackerWeb.Plugs.BackerSelfCheck do
  def init(_params) do
  end

  def call(conn, _params) do
    if conn.params["username"] != conn.assigns.current_backer.username do
      Phoenix.Controller.redirect(conn, to: "/400")
    else
      conn
    end
  end
end
