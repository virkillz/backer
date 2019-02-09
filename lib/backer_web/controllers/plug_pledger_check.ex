defmodule BackerWeb.Plugs.PledgerCheck do
  import Plug.Conn

  alias Backer.Repo
  alias Backer.Account

  def init(_params) do
  end

  def call(conn, _params) do


    if conn.assigns.backer_signed_in? do

      backer_id = conn.assigns.current_backer.id

      if Account.get_pledger(%{"backer_id" => backer_id}) != nil do
        conn
      else
        Phoenix.Controller.redirect(conn, to: "/400")
      end
    end


  end
end
