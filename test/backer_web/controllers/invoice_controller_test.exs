defmodule BackerWeb.InvoiceControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{amount: 42, method: "some method", status: "some status"}
  @update_attrs %{amount: 43, method: "some updated method", status: "some updated status"}
  @invalid_attrs %{amount: nil, method: nil, status: nil}

  def fixture(:invoice) do
    {:ok, invoice} = Finance.create_invoice(@create_attrs)
    invoice
  end

  describe "index" do
    test "lists all invoices", %{conn: conn} do
      conn = get(conn, invoice_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Invoices"
    end
  end

  describe "new invoice" do
    test "renders form", %{conn: conn} do
      conn = get(conn, invoice_path(conn, :new))
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "create invoice" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, invoice_path(conn, :create), invoice: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == invoice_path(conn, :show, id)

      conn = get(conn, invoice_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Invoice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, invoice_path(conn, :create), invoice: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "edit invoice" do
    setup [:create_invoice]

    test "renders form for editing chosen invoice", %{conn: conn, invoice: invoice} do
      conn = get(conn, invoice_path(conn, :edit, invoice))
      assert html_response(conn, 200) =~ "Edit Invoice"
    end
  end

  describe "update invoice" do
    setup [:create_invoice]

    test "redirects when data is valid", %{conn: conn, invoice: invoice} do
      conn = put(conn, invoice_path(conn, :update, invoice), invoice: @update_attrs)
      assert redirected_to(conn) == invoice_path(conn, :show, invoice)

      conn = get(conn, invoice_path(conn, :show, invoice))
      assert html_response(conn, 200) =~ "some updated method"
    end

    test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
      conn = put(conn, invoice_path(conn, :update, invoice), invoice: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Invoice"
    end
  end

  describe "delete invoice" do
    setup [:create_invoice]

    test "deletes chosen invoice", %{conn: conn, invoice: invoice} do
      conn = delete(conn, invoice_path(conn, :delete, invoice))
      assert redirected_to(conn) == invoice_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, invoice_path(conn, :show, invoice))
      end)
    end
  end

  defp create_invoice(_) do
    invoice = fixture(:invoice)
    {:ok, invoice: invoice}
  end
end
