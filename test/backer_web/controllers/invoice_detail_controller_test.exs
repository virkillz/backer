defmodule BackerWeb.InvoiceDetailControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{amount: 42, month: 42, type: "some type", year: 42}
  @update_attrs %{amount: 43, month: 43, type: "some updated type", year: 43}
  @invalid_attrs %{amount: nil, month: nil, type: nil, year: nil}

  def fixture(:invoice_detail) do
    {:ok, invoice_detail} = Finance.create_invoice_detail(@create_attrs)
    invoice_detail
  end

  describe "index" do
    test "lists all invoice_details", %{conn: conn} do
      conn = get(conn, invoice_detail_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Invoice details"
    end
  end

  describe "new invoice_detail" do
    test "renders form", %{conn: conn} do
      conn = get(conn, invoice_detail_path(conn, :new))
      assert html_response(conn, 200) =~ "New Invoice detail"
    end
  end

  describe "create invoice_detail" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, invoice_detail_path(conn, :create), invoice_detail: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == invoice_detail_path(conn, :show, id)

      conn = get(conn, invoice_detail_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Invoice detail"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, invoice_detail_path(conn, :create), invoice_detail: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Invoice detail"
    end
  end

  describe "edit invoice_detail" do
    setup [:create_invoice_detail]

    test "renders form for editing chosen invoice_detail", %{
      conn: conn,
      invoice_detail: invoice_detail
    } do
      conn = get(conn, invoice_detail_path(conn, :edit, invoice_detail))
      assert html_response(conn, 200) =~ "Edit Invoice detail"
    end
  end

  describe "update invoice_detail" do
    setup [:create_invoice_detail]

    test "redirects when data is valid", %{conn: conn, invoice_detail: invoice_detail} do
      conn =
        put(conn, invoice_detail_path(conn, :update, invoice_detail),
          invoice_detail: @update_attrs
        )

      assert redirected_to(conn) == invoice_detail_path(conn, :show, invoice_detail)

      conn = get(conn, invoice_detail_path(conn, :show, invoice_detail))
      assert html_response(conn, 200) =~ "some updated type"
    end

    test "renders errors when data is invalid", %{conn: conn, invoice_detail: invoice_detail} do
      conn =
        put(conn, invoice_detail_path(conn, :update, invoice_detail),
          invoice_detail: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Invoice detail"
    end
  end

  describe "delete invoice_detail" do
    setup [:create_invoice_detail]

    test "deletes chosen invoice_detail", %{conn: conn, invoice_detail: invoice_detail} do
      conn = delete(conn, invoice_detail_path(conn, :delete, invoice_detail))
      assert redirected_to(conn) == invoice_detail_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, invoice_detail_path(conn, :show, invoice_detail))
      end)
    end
  end

  defp create_invoice_detail(_) do
    invoice_detail = fixture(:invoice_detail)
    {:ok, invoice_detail: invoice_detail}
  end
end
