defmodule BackerWeb.SettlementControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{amount: 42, evidence: "some evidence", method: "some method", net_amount: 42, platform_fee: 42, platform_fee_percentage: 42, status: "some status", tax: 42, transaction_date: ~N[2010-04-17 14:00:00], transaction_fee: 42, tx_id: "some tx_id"}
  @update_attrs %{amount: 43, evidence: "some updated evidence", method: "some updated method", net_amount: 43, platform_fee: 43, platform_fee_percentage: 43, status: "some updated status", tax: 43, transaction_date: ~N[2011-05-18 15:01:01], transaction_fee: 43, tx_id: "some updated tx_id"}
  @invalid_attrs %{amount: nil, evidence: nil, method: nil, net_amount: nil, platform_fee: nil, platform_fee_percentage: nil, status: nil, tax: nil, transaction_date: nil, transaction_fee: nil, tx_id: nil}

  def fixture(:settlement) do
    {:ok, settlement} = Finance.create_settlement(@create_attrs)
    settlement
  end

  describe "index" do
    test "lists all settlements", %{conn: conn} do
      conn = get conn, settlement_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Settlements"
    end
  end

  describe "new settlement" do
    test "renders form", %{conn: conn} do
      conn = get conn, settlement_path(conn, :new)
      assert html_response(conn, 200) =~ "New Settlement"
    end
  end

  describe "create settlement" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, settlement_path(conn, :create), settlement: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == settlement_path(conn, :show, id)

      conn = get conn, settlement_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Settlement"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, settlement_path(conn, :create), settlement: @invalid_attrs
      assert html_response(conn, 200) =~ "New Settlement"
    end
  end

  describe "edit settlement" do
    setup [:create_settlement]

    test "renders form for editing chosen settlement", %{conn: conn, settlement: settlement} do
      conn = get conn, settlement_path(conn, :edit, settlement)
      assert html_response(conn, 200) =~ "Edit Settlement"
    end
  end

  describe "update settlement" do
    setup [:create_settlement]

    test "redirects when data is valid", %{conn: conn, settlement: settlement} do
      conn = put conn, settlement_path(conn, :update, settlement), settlement: @update_attrs
      assert redirected_to(conn) == settlement_path(conn, :show, settlement)

      conn = get conn, settlement_path(conn, :show, settlement)
      assert html_response(conn, 200) =~ "some updated evidence"
    end

    test "renders errors when data is invalid", %{conn: conn, settlement: settlement} do
      conn = put conn, settlement_path(conn, :update, settlement), settlement: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Settlement"
    end
  end

  describe "delete settlement" do
    setup [:create_settlement]

    test "deletes chosen settlement", %{conn: conn, settlement: settlement} do
      conn = delete conn, settlement_path(conn, :delete, settlement)
      assert redirected_to(conn) == settlement_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, settlement_path(conn, :show, settlement)
      end
    end
  end

  defp create_settlement(_) do
    settlement = fixture(:settlement)
    {:ok, settlement: settlement}
  end
end
