defmodule BackerWeb.SettlementController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.Settlement
  alias Backer.Account

  def index(conn, _params) do
    settlements = Finance.list_settlements()
    render(conn, "index.html", settlements: settlements)
  end

  def new(conn, _params) do
    donees = Finance.list_unsettled_donee()

    changeset = Finance.change_settlement(%Settlement{})
    render(conn, "new.html", changeset: changeset, donees: donees)
  end

  def build_settlement(conn, %{"id" => id}) do
    Finance.get_unsettled_donee(id)
    text(conn, "test")
  end

  def create(conn, %{"settlement" => settlement_params}) do
    IO.inspect(settlement_params)

    case Finance.initiate_settlement(settlement_params) do
      {:ok, settlement} ->
        conn
        |> put_flash(:info, "Settlement created successfully.")
        |> redirect(to: Router.settlement_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)
    render(conn, "show.html", settlement: settlement)
  end

  def edit(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)
    changeset = Finance.change_settlement(settlement)
    render(conn, "edit.html", settlement: settlement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "settlement" => settlement_params}) do
    settlement = Finance.get_settlement!(id)

    case Finance.update_settlement(settlement, settlement_params) do
      {:ok, settlement} ->
        conn
        |> put_flash(:info, "Settlement updated successfully.")
        |> redirect(to: Router.settlement_path(conn, :show, settlement))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", settlement: settlement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)
    {:ok, _settlement} = Finance.delete_settlement(settlement)

    conn
    |> put_flash(:info, "Settlement deleted successfully.")
    |> redirect(to: Router.settlement_path(conn, :index))
  end
end
