defmodule BackerWeb.InvoiceDetailController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.InvoiceDetail

  def index(conn, _params) do
    invoice_details = Finance.list_invoice_details()
    render(conn, "index.html", invoice_details: invoice_details)
  end

  def new(conn, _params) do
    changeset = Finance.change_invoice_detail(%InvoiceDetail{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invoice_detail" => invoice_detail_params}) do
    case Finance.create_invoice_detail(invoice_detail_params) do
      {:ok, invoice_detail} ->
        conn
        |> put_flash(:info, "Invoice detail created successfully.")
        |> redirect(to: invoice_detail_path(conn, :show, invoice_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invoice_detail = Finance.get_invoice_detail!(id)
    render(conn, "show.html", invoice_detail: invoice_detail)
  end

  def edit(conn, %{"id" => id}) do
    invoice_detail = Finance.get_invoice_detail!(id)
    changeset = Finance.change_invoice_detail(invoice_detail)
    render(conn, "edit.html", invoice_detail: invoice_detail, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invoice_detail" => invoice_detail_params}) do
    invoice_detail = Finance.get_invoice_detail!(id)

    case Finance.update_invoice_detail(invoice_detail, invoice_detail_params) do
      {:ok, invoice_detail} ->
        conn
        |> put_flash(:info, "Invoice detail updated successfully.")
        |> redirect(to: invoice_detail_path(conn, :show, invoice_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invoice_detail: invoice_detail, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice_detail = Finance.get_invoice_detail!(id)
    {:ok, _invoice_detail} = Finance.delete_invoice_detail(invoice_detail)

    conn
    |> put_flash(:info, "Invoice detail deleted successfully.")
    |> redirect(to: invoice_detail_path(conn, :index))
  end
end
