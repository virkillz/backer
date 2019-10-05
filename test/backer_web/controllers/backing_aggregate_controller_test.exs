defmodule BackerWeb.BackingAggregateControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Aggregate

  @create_attrs %{accumulative_donation: 42, backer_since: ~N[2010-04-17 14:00:00], backing_status: "some backing_status", last_amount: 42, last_tier: "some last_tier", score: 42}
  @update_attrs %{accumulative_donation: 43, backer_since: ~N[2011-05-18 15:01:01], backing_status: "some updated backing_status", last_amount: 43, last_tier: "some updated last_tier", score: 43}
  @invalid_attrs %{accumulative_donation: nil, backer_since: nil, backing_status: nil, last_amount: nil, last_tier: nil, score: nil}

  def fixture(:backing_aggregate) do
    {:ok, backing_aggregate} = Aggregate.create_backing_aggregate(@create_attrs)
    backing_aggregate
  end

  describe "index" do
    test "lists all backingaggregates", %{conn: conn} do
      conn = get conn, backing_aggregate_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Backingaggregates"
    end
  end

  describe "new backing_aggregate" do
    test "renders form", %{conn: conn} do
      conn = get conn, backing_aggregate_path(conn, :new)
      assert html_response(conn, 200) =~ "New Backing aggregate"
    end
  end

  describe "create backing_aggregate" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, backing_aggregate_path(conn, :create), backing_aggregate: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == backing_aggregate_path(conn, :show, id)

      conn = get conn, backing_aggregate_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Backing aggregate"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, backing_aggregate_path(conn, :create), backing_aggregate: @invalid_attrs
      assert html_response(conn, 200) =~ "New Backing aggregate"
    end
  end

  describe "edit backing_aggregate" do
    setup [:create_backing_aggregate]

    test "renders form for editing chosen backing_aggregate", %{conn: conn, backing_aggregate: backing_aggregate} do
      conn = get conn, backing_aggregate_path(conn, :edit, backing_aggregate)
      assert html_response(conn, 200) =~ "Edit Backing aggregate"
    end
  end

  describe "update backing_aggregate" do
    setup [:create_backing_aggregate]

    test "redirects when data is valid", %{conn: conn, backing_aggregate: backing_aggregate} do
      conn = put conn, backing_aggregate_path(conn, :update, backing_aggregate), backing_aggregate: @update_attrs
      assert redirected_to(conn) == backing_aggregate_path(conn, :show, backing_aggregate)

      conn = get conn, backing_aggregate_path(conn, :show, backing_aggregate)
      assert html_response(conn, 200) =~ "some updated backing_status"
    end

    test "renders errors when data is invalid", %{conn: conn, backing_aggregate: backing_aggregate} do
      conn = put conn, backing_aggregate_path(conn, :update, backing_aggregate), backing_aggregate: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Backing aggregate"
    end
  end

  describe "delete backing_aggregate" do
    setup [:create_backing_aggregate]

    test "deletes chosen backing_aggregate", %{conn: conn, backing_aggregate: backing_aggregate} do
      conn = delete conn, backing_aggregate_path(conn, :delete, backing_aggregate)
      assert redirected_to(conn) == backing_aggregate_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, backing_aggregate_path(conn, :show, backing_aggregate)
      end
    end
  end

  defp create_backing_aggregate(_) do
    backing_aggregate = fixture(:backing_aggregate)
    {:ok, backing_aggregate: backing_aggregate}
  end
end
