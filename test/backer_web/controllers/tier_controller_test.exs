defmodule BackerWeb.TierControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Masterdata

  @create_attrs %{amount: 42, description: "some description", title: "some title"}
  @update_attrs %{
    amount: 43,
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{amount: nil, description: nil, title: nil}

  def fixture(:tier) do
    {:ok, tier} = Masterdata.create_tier(@create_attrs)
    tier
  end

  describe "index" do
    test "lists all tiers", %{conn: conn} do
      conn = get(conn, tier_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tiers"
    end
  end

  describe "new tier" do
    test "renders form", %{conn: conn} do
      conn = get(conn, tier_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tier"
    end
  end

  describe "create tier" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, tier_path(conn, :create), tier: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == tier_path(conn, :show, id)

      conn = get(conn, tier_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tier"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, tier_path(conn, :create), tier: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tier"
    end
  end

  describe "edit tier" do
    setup [:create_tier]

    test "renders form for editing chosen tier", %{conn: conn, tier: tier} do
      conn = get(conn, tier_path(conn, :edit, tier))
      assert html_response(conn, 200) =~ "Edit Tier"
    end
  end

  describe "update tier" do
    setup [:create_tier]

    test "redirects when data is valid", %{conn: conn, tier: tier} do
      conn = put(conn, tier_path(conn, :update, tier), tier: @update_attrs)
      assert redirected_to(conn) == tier_path(conn, :show, tier)

      conn = get(conn, tier_path(conn, :show, tier))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, tier: tier} do
      conn = put(conn, tier_path(conn, :update, tier), tier: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tier"
    end
  end

  describe "delete tier" do
    setup [:create_tier]

    test "deletes chosen tier", %{conn: conn, tier: tier} do
      conn = delete(conn, tier_path(conn, :delete, tier))
      assert redirected_to(conn) == tier_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, tier_path(conn, :show, tier))
      end)
    end
  end

  defp create_tier(_) do
    tier = fixture(:tier)
    {:ok, tier: tier}
  end
end
