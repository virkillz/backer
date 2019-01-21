defmodule BackerWeb.InvoiceController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Constant

  alias Backer.Finance
  alias Backer.Finance.Invoice

  def index(conn, _params) do
    invoices = Finance.list_invoices()
    render(conn, "index.html", invoices: invoices)
  end

  def newdeposit(conn, _params) do
    backers = Account.list_backers
    methods = Constant.payment_method_deposit
    changeset = Finance.change_invoice(%Invoice{})
    render(conn, "new_deposit.html", changeset: changeset, backers: backers, methods: methods)
  end

  def newbacking(conn, _params) do
    changeset = Finance.change_invoice(%Invoice{})
    render(conn, "new.html", changeset: changeset)
  end  

  def create_deposit(conn, %{"invoice" => params}) do

    invoice_params = params |> Map.put("type", "deposit")

    case Finance.create_invoice(invoice_params) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "Invoice created successfully.")
        |> redirect(to: invoice_path(conn, :show, invoice))
      {:error, %Ecto.Changeset{} = changeset} ->
      backers = Account.list_backers
      methods = Constant.payment_method_deposit     
        render(conn, "new_deposit.html", changeset: changeset, backers: backers, methods: methods)
    end
  end


  def create(conn, %{"invoice" => invoice_params}) do
    case Finance.create_invoice(invoice_params) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "Invoice created successfully.")
        |> redirect(to: invoice_path(conn, :show, invoice))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invoice = Finance.get_invoice!(id)
    invoice_details = Finance.get_invoice_detail(%{"invoice_id" => id}) |> IO.inspect
    render(conn, "show.html", invoice: invoice, invoice_details: invoice_details)
  end

  def edit(conn, %{"id" => id}) do
    invoice = Finance.get_invoice!(id)
    invoice_status = Constant.invoice_status
    changeset = Finance.change_invoice(invoice)
    render(conn, "edit.html", invoice: invoice, changeset: changeset, invoice_status: invoice_status)
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Finance.get_invoice!(id)

    case Finance.update_invoice(invoice, invoice_params) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "Invoice updated successfully.")
        |> redirect(to: invoice_path(conn, :show, invoice))
      {:error, %Ecto.Changeset{} = changeset} ->
            invoice_status = Constant.invoice_status
        render(conn, "edit.html", invoice: invoice, changeset: changeset, invoice_status: invoice_status)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Finance.get_invoice!(id)
    {:ok, _invoice} = Finance.delete_invoice(invoice)

    conn
    |> put_flash(:info, "Invoice deleted successfully.")
    |> redirect(to: invoice_path(conn, :index))
  end
end
