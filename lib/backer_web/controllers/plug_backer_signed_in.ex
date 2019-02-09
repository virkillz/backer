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
      conn
      |> Phoenix.Controller.put_flash(:info, "You need to login first.")
      |> Phoenix.Controller.redirect(to: "/login")
    end
  end
end
