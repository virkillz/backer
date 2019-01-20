defmodule BackerWeb.WithdrawalControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{amount: 42, fee: 42, net_ammount: 42, status: "some status", tx_details: "some tx_details", tx_id: "some tx_id", tx_image: "some tx_image"}
  @update_attrs %{amount: 43, fee: 43, net_ammount: 43, status: "some updated status", tx_details: "some updated tx_details", tx_id: "some updated tx_id", tx_image: "some updated tx_image"}
  @invalid_attrs %{amount: nil, fee: nil, net_ammount: nil, status: nil, tx_details: nil, tx_id: nil, tx_image: nil}

  def fixture(:withdrawal) do
    {:ok, withdrawal} = Finance.create_withdrawal(@create_attrs)
    withdrawal
  end

  describe "index" do
    test "lists all withdrawals", %{conn: conn} do
      conn = get conn, withdrawal_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Withdrawals"
    end
  end

  describe "new withdrawal" do
    test "renders form", %{conn: conn} do
      conn = get conn, withdrawal_path(conn, :new)
      assert html_response(conn, 200) =~ "New Withdrawal"
    end
  end

  describe "create withdrawal" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, withdrawal_path(conn, :create), withdrawal: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == withdrawal_path(conn, :show, id)

      conn = get conn, withdrawal_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Withdrawal"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, withdrawal_path(conn, :create), withdrawal: @invalid_attrs
      assert html_response(conn, 200) =~ "New Withdrawal"
    end
  end

  describe "edit withdrawal" do
    setup [:create_withdrawal]

    test "renders form for editing chosen withdrawal", %{conn: conn, withdrawal: withdrawal} do
      conn = get conn, withdrawal_path(conn, :edit, withdrawal)
      assert html_response(conn, 200) =~ "Edit Withdrawal"
    end
  end

  describe "update withdrawal" do
    setup [:create_withdrawal]

    test "redirects when data is valid", %{conn: conn, withdrawal: withdrawal} do
      conn = put conn, withdrawal_path(conn, :update, withdrawal), withdrawal: @update_attrs
      assert redirected_to(conn) == withdrawal_path(conn, :show, withdrawal)

      conn = get conn, withdrawal_path(conn, :show, withdrawal)
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, withdrawal: withdrawal} do
      conn = put conn, withdrawal_path(conn, :update, withdrawal), withdrawal: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Withdrawal"
    end
  end

  describe "delete withdrawal" do
    setup [:create_withdrawal]

    test "deletes chosen withdrawal", %{conn: conn, withdrawal: withdrawal} do
      conn = delete conn, withdrawal_path(conn, :delete, withdrawal)
      assert redirected_to(conn) == withdrawal_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, withdrawal_path(conn, :show, withdrawal)
      end
    end
  end

  defp create_withdrawal(_) do
    withdrawal = fixture(:withdrawal)
    {:ok, withdrawal: withdrawal}
  end
end
