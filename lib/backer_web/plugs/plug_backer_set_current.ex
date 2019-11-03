defmodule BackerWeb.Plugs.SetCurrentBacker do
  import Plug.Conn

  alias Backer.Repo
  alias Backer.Account
  alias Backer.Account.Backer, as: Backerz

  def init(_params) do
  end

  def call(conn, _params) do
    backer_id = Plug.Conn.get_session(conn, :current_backer_id)

    if is_nil(backer_id) do
      conn
      |> assign(:current_backer, nil)
      |> assign(:backer_signed_in?, false)
    else
      current_backer = Account.get_backer_preload_donee(backer_id)

      if is_nil(current_backer) do
        conn
        |> assign(:current_backer, nil)
        |> assign(:backer_signed_in?, false)
      else
        conn
        |> assign(:current_backer, current_backer)
        |> assign(:backer_signed_in?, true)
      end
    end

    # cond do
    #   current_backer = backer_id && Account.get_backer_preload_donee(backer_id) ->
    #     conn
    #     |> assign(:current_backer, current_backer)
    #     |> assign(:backer_signed_in?, true)

    #   true ->
    #     conn
    #     |> assign(:current_backer, nil)
    #     |> assign(:backer_signed_in?, false)
    # end

    # cond do
    #   current_backer = backer_id && Repo.get(Backerz, backer_id) ->
    #     conn
    #     |> assign(:current_backer, current_backer)
    #     |> assign(:backer_signed_in?, true)

    #   true ->
    #     conn
    #     |> assign(:current_backer, nil)
    #     |> assign(:backer_signed_in?, false)
    # end
  end
end
