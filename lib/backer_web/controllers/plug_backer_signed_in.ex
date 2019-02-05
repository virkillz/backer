defmodule BackerWeb.Plugs.BackerSignCheck do
  import Plug.Conn

  alias Backer.Repo
  alias Backer.Account.Backer, as: Backerz

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.backer_signed_in? do
      conn
    else
      Phoenix.Controller.redirect(conn, to: "/505")
    end
  end
end
