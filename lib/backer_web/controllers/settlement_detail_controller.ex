defmodule BackerWeb.SettlementDetailController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.SettlementDetail

  def index(conn, _params) do
    settlement_details = Finance.list_settlement_details()
    render(conn, "index.html", settlement_details: settlement_details)
  end

  def new(conn, _params) do
    changeset = Finance.change_settlement_detail(%SettlementDetail{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"settlement_detail" => settlement_detail_params}) do
    case Finance.create_settlement_detail(settlement_detail_params) do
      {:ok, settlement_detail} ->
        conn
        |> put_flash(:info, "Settlement detail created successfully.")
        |> redirect(to: Router.settlement_detail_path(conn, :show, settlement_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    settlement_detail = Finance.get_settlement_detail!(id)
    render(conn, "show.html", settlement_detail: settlement_detail)
  end

  def edit(conn, %{"id" => id}) do
    settlement_detail = Finance.get_settlement_detail!(id)
    changeset = Finance.change_settlement_detail(settlement_detail)
    render(conn, "edit.html", settlement_detail: settlement_detail, changeset: changeset)
  end

  def update(conn, %{"id" => id, "settlement_detail" => settlement_detail_params}) do
    settlement_detail = Finance.get_settlement_detail!(id)

    case Finance.update_settlement_detail(settlement_detail, settlement_detail_params) do
      {:ok, settlement_detail} ->
        conn
        |> put_flash(:info, "Settlement detail updated successfully.")
        |> redirect(to: Router.settlement_detail_path(conn, :show, settlement_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", settlement_detail: settlement_detail, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    settlement_detail = Finance.get_settlement_detail!(id)
    {:ok, _settlement_detail} = Finance.delete_settlement_detail(settlement_detail)

    conn
    |> put_flash(:info, "Settlement detail deleted successfully.")
    |> redirect(to: Router.settlement_detail_path(conn, :index))
  end
end
