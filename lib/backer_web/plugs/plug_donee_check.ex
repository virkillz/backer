defmodule BackerWeb.Plugs.DoneeCheck do
  import Plug.Conn

  alias Backer.Account

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.backer_signed_in? do
      backer_id = conn.assigns.current_backer.id

      current_donee = Account.get_donee_compact(%{"backer_id" => backer_id})

      if current_donee != nil do
        conn |> assign(:current_donee, current_donee)
      else
        Phoenix.Controller.redirect(conn, to: "/400")
      end
    end
  end
end
