defmodule BackerWeb.PaymentAccountControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Account

  @create_attrs %{account_holder_name: "some account_holder_name", account_number: "some account_number", branch: "some branch", email_ref: "some email_ref", other_ref: "some other_ref", ownership_evidence: "some ownership_evidence", phone_ref: "some phone_ref", type: "some type"}
  @update_attrs %{account_holder_name: "some updated account_holder_name", account_number: "some updated account_number", branch: "some updated branch", email_ref: "some updated email_ref", other_ref: "some updated other_ref", ownership_evidence: "some updated ownership_evidence", phone_ref: "some updated phone_ref", type: "some updated type"}
  @invalid_attrs %{account_holder_name: nil, account_number: nil, branch: nil, email_ref: nil, other_ref: nil, ownership_evidence: nil, phone_ref: nil, type: nil}

  def fixture(:payment_account) do
    {:ok, payment_account} = Account.create_payment_account(@create_attrs)
    payment_account
  end

  describe "index" do
    test "lists all payment_accounts", %{conn: conn} do
      conn = get conn, payment_account_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Payment accounts"
    end
  end

  describe "new payment_account" do
    test "renders form", %{conn: conn} do
      conn = get conn, payment_account_path(conn, :new)
      assert html_response(conn, 200) =~ "New Payment account"
    end
  end

  describe "create payment_account" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, payment_account_path(conn, :create), payment_account: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == payment_account_path(conn, :show, id)

      conn = get conn, payment_account_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Payment account"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_account_path(conn, :create), payment_account: @invalid_attrs
      assert html_response(conn, 200) =~ "New Payment account"
    end
  end

  describe "edit payment_account" do
    setup [:create_payment_account]

    test "renders form for editing chosen payment_account", %{conn: conn, payment_account: payment_account} do
      conn = get conn, payment_account_path(conn, :edit, payment_account)
      assert html_response(conn, 200) =~ "Edit Payment account"
    end
  end

  describe "update payment_account" do
    setup [:create_payment_account]

    test "redirects when data is valid", %{conn: conn, payment_account: payment_account} do
      conn = put conn, payment_account_path(conn, :update, payment_account), payment_account: @update_attrs
      assert redirected_to(conn) == payment_account_path(conn, :show, payment_account)

      conn = get conn, payment_account_path(conn, :show, payment_account)
      assert html_response(conn, 200) =~ "some updated account_holder_name"
    end

    test "renders errors when data is invalid", %{conn: conn, payment_account: payment_account} do
      conn = put conn, payment_account_path(conn, :update, payment_account), payment_account: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Payment account"
    end
  end

  describe "delete payment_account" do
    setup [:create_payment_account]

    test "deletes chosen payment_account", %{conn: conn, payment_account: payment_account} do
      conn = delete conn, payment_account_path(conn, :delete, payment_account)
      assert redirected_to(conn) == payment_account_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, payment_account_path(conn, :show, payment_account)
      end
    end
  end

  defp create_payment_account(_) do
    payment_account = fixture(:payment_account)
    {:ok, payment_account: payment_account}
  end
end
