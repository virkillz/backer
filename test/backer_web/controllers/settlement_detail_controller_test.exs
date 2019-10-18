defmodule BackerWeb.SettlementDetailControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{amount: 42, remark: "some remark"}
  @update_attrs %{amount: 43, remark: "some updated remark"}
  @invalid_attrs %{amount: nil, remark: nil}

  def fixture(:settlement_detail) do
    {:ok, settlement_detail} = Finance.create_settlement_detail(@create_attrs)
    settlement_detail
  end

  describe "index" do
    test "lists all settlement_details", %{conn: conn} do
      conn = get conn, settlement_detail_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Settlement details"
    end
  end

  describe "new settlement_detail" do
    test "renders form", %{conn: conn} do
      conn = get conn, settlement_detail_path(conn, :new)
      assert html_response(conn, 200) =~ "New Settlement detail"
    end
  end

  describe "create settlement_detail" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, settlement_detail_path(conn, :create), settlement_detail: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == settlement_detail_path(conn, :show, id)

      conn = get conn, settlement_detail_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Settlement detail"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, settlement_detail_path(conn, :create), settlement_detail: @invalid_attrs
      assert html_response(conn, 200) =~ "New Settlement detail"
    end
  end

  describe "edit settlement_detail" do
    setup [:create_settlement_detail]

    test "renders form for editing chosen settlement_detail", %{conn: conn, settlement_detail: settlement_detail} do
      conn = get conn, settlement_detail_path(conn, :edit, settlement_detail)
      assert html_response(conn, 200) =~ "Edit Settlement detail"
    end
  end

  describe "update settlement_detail" do
    setup [:create_settlement_detail]

    test "redirects when data is valid", %{conn: conn, settlement_detail: settlement_detail} do
      conn = put conn, settlement_detail_path(conn, :update, settlement_detail), settlement_detail: @update_attrs
      assert redirected_to(conn) == settlement_detail_path(conn, :show, settlement_detail)

      conn = get conn, settlement_detail_path(conn, :show, settlement_detail)
      assert html_response(conn, 200) =~ "some updated remark"
    end

    test "renders errors when data is invalid", %{conn: conn, settlement_detail: settlement_detail} do
      conn = put conn, settlement_detail_path(conn, :update, settlement_detail), settlement_detail: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Settlement detail"
    end
  end

  describe "delete settlement_detail" do
    setup [:create_settlement_detail]

    test "deletes chosen settlement_detail", %{conn: conn, settlement_detail: settlement_detail} do
      conn = delete conn, settlement_detail_path(conn, :delete, settlement_detail)
      assert redirected_to(conn) == settlement_detail_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, settlement_detail_path(conn, :show, settlement_detail)
      end
    end
  end

  defp create_settlement_detail(_) do
    settlement_detail = fixture(:settlement_detail)
    {:ok, settlement_detail: settlement_detail}
  end
end
