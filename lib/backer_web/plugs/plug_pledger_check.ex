defmodule BackerWeb.Plugs.PledgerCheck do
  import Plug.Conn

  alias Backer.Account

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.backer_signed_in? do
      backer_id = conn.assigns.current_backer.id

      current_pledger = Account.get_pledger_compact(%{"backer_id" => backer_id})

      if current_pledger != nil do
        conn |> assign(:current_pledger, current_pledger)
      else
        Phoenix.Controller.redirect(conn, to: "/400")
      end
    end
  end
end
