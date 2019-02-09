defmodule BackerWeb.IncomingPaymentControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{
    action: "some action",
    amount: 42,
    destination: "some destination",
    details: "some details",
    evidence: "some evidence",
    source: "some source",
    status: "some status",
    tx_id: "some tx_id"
  }
  @update_attrs %{
    action: "some updated action",
    amount: 43,
    destination: "some updated destination",
    details: "some updated details",
    evidence: "some updated evidence",
    source: "some updated source",
    status: "some updated status",
    tx_id: "some updated tx_id"
  }
  @invalid_attrs %{
    action: nil,
    amount: nil,
    destination: nil,
    details: nil,
    evidence: nil,
    source: nil,
    status: nil,
    tx_id: nil
  }

  def fixture(:incoming_payment) do
    {:ok, incoming_payment} = Finance.create_incoming_payment(@create_attrs)
    incoming_payment
  end

  describe "index" do
    test "lists all incoming_payments", %{conn: conn} do
      conn = get(conn, incoming_payment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Incoming payments"
    end
  end

  describe "new incoming_payment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, incoming_payment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Incoming payment"
    end
  end

  describe "create incoming_payment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, incoming_payment_path(conn, :create), incoming_payment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == incoming_payment_path(conn, :show, id)

      conn = get(conn, incoming_payment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Incoming payment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, incoming_payment_path(conn, :create), incoming_payment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Incoming payment"
    end
  end

  describe "edit incoming_payment" do
    setup [:create_incoming_payment]

    test "renders form for editing chosen incoming_payment", %{
      conn: conn,
      incoming_payment: incoming_payment
    } do
      conn = get(conn, incoming_payment_path(conn, :edit, incoming_payment))
      assert html_response(conn, 200) =~ "Edit Incoming payment"
    end
  end

  describe "update incoming_payment" do
    setup [:create_incoming_payment]

    test "redirects when data is valid", %{conn: conn, incoming_payment: incoming_payment} do
      conn =
        put(conn, incoming_payment_path(conn, :update, incoming_payment),
          incoming_payment: @update_attrs
        )

      assert redirected_to(conn) == incoming_payment_path(conn, :show, incoming_payment)

      conn = get(conn, incoming_payment_path(conn, :show, incoming_payment))
      assert html_response(conn, 200) =~ "some updated action"
    end

    test "renders errors when data is invalid", %{conn: conn, incoming_payment: incoming_payment} do
      conn =
        put(conn, incoming_payment_path(conn, :update, incoming_payment),
          incoming_payment: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Incoming payment"
    end
  end

  describe "delete incoming_payment" do
    setup [:create_incoming_payment]

    test "deletes chosen incoming_payment", %{conn: conn, incoming_payment: incoming_payment} do
      conn = delete(conn, incoming_payment_path(conn, :delete, incoming_payment))
      assert redirected_to(conn) == incoming_payment_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, incoming_payment_path(conn, :show, incoming_payment))
      end)
    end
  end

  defp create_incoming_payment(_) do
    incoming_payment = fixture(:incoming_payment)
    {:ok, incoming_payment: incoming_payment}
  end
end
