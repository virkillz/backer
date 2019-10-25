defmodule BackerWeb.Plugs.SetCurrentBacker do
  import Plug.Conn

  alias Backer.Repo
  alias Backer.Account.Backer, as: Backerz

  def init(_params) do
  end

  def call(conn, _params) do
    backer_id = Plug.Conn.get_session(conn, :current_backer_id)

    if (current_backer = backer_id) && Repo.get(Backerz, backer_id) do
      conn
      |> assign(:current_backer, current_backer)
      |> assign(:backer_signed_in?, true)
    else
      conn
      |> assign(:current_backer, nil)
      |> assign(:backer_signed_in?, false)
    end
  end
end
