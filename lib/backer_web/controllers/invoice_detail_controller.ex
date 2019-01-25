defmodule BackerWeb.InvoiceDetailController do
  use BackerWeb, :controller

  alias Backer.Finance
  # alias Backer.Finance.InvoiceDetail

  def index(conn, params) do
    invoice_details = Finance.list_invoice_details(params)
    render(conn, "index.html", invoice_details: invoice_details)
  end

  def show(conn, %{"id" => id}) do
    invoice_detail = Finance.get_invoice_detail!(id)
    render(conn, "show.html", invoice_detail: invoice_detail)
  end


end
