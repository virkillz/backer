defmodule BackerWeb.BadgeMemberControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Gamification

  @create_attrs %{award_date: ~D[2010-04-17]}
  @update_attrs %{award_date: ~D[2011-05-18]}
  @invalid_attrs %{award_date: nil}

  def fixture(:badge_member) do
    {:ok, badge_member} = Gamification.create_badge_member(@create_attrs)
    badge_member
  end

  describe "index" do
    test "lists all badge_members", %{conn: conn} do
      conn = get(conn, badge_member_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Badge members"
    end
  end

  describe "new badge_member" do
    test "renders form", %{conn: conn} do
      conn = get(conn, badge_member_path(conn, :new))
      assert html_response(conn, 200) =~ "New Badge member"
    end
  end

  describe "create badge_member" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, badge_member_path(conn, :create), badge_member: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == badge_member_path(conn, :show, id)

      conn = get(conn, badge_member_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Badge member"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, badge_member_path(conn, :create), badge_member: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Badge member"
    end
  end

  describe "edit badge_member" do
    setup [:create_badge_member]

    test "renders form for editing chosen badge_member", %{conn: conn, badge_member: badge_member} do
      conn = get(conn, badge_member_path(conn, :edit, badge_member))
      assert html_response(conn, 200) =~ "Edit Badge member"
    end
  end

  describe "update badge_member" do
    setup [:create_badge_member]

    test "redirects when data is valid", %{conn: conn, badge_member: badge_member} do
      conn =
        put(conn, badge_member_path(conn, :update, badge_member), badge_member: @update_attrs)

      assert redirected_to(conn) == badge_member_path(conn, :show, badge_member)

      conn = get(conn, badge_member_path(conn, :show, badge_member))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, badge_member: badge_member} do
      conn =
        put(conn, badge_member_path(conn, :update, badge_member), badge_member: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Badge member"
    end
  end

  describe "delete badge_member" do
    setup [:create_badge_member]

    test "deletes chosen badge_member", %{conn: conn, badge_member: badge_member} do
      conn = delete(conn, badge_member_path(conn, :delete, badge_member))
      assert redirected_to(conn) == badge_member_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, badge_member_path(conn, :show, badge_member))
      end)
    end
  end

  defp create_badge_member(_) do
    badge_member = fixture(:badge_member)
    {:ok, badge_member: badge_member}
  end
end
