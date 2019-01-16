defmodule BackerWeb.BadgeControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Gamification

  @create_attrs %{description: "some description", icon: "some icon", title: "some title"}
  @update_attrs %{
    description: "some updated description",
    icon: "some updated icon",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, icon: nil, title: nil}

  def fixture(:badge) do
    {:ok, badge} = Gamification.create_badge(@create_attrs)
    badge
  end

  describe "index" do
    test "lists all badges", %{conn: conn} do
      conn = get(conn, badge_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Badges"
    end
  end

  describe "new badge" do
    test "renders form", %{conn: conn} do
      conn = get(conn, badge_path(conn, :new))
      assert html_response(conn, 200) =~ "New Badge"
    end
  end

  describe "create badge" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, badge_path(conn, :create), badge: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == badge_path(conn, :show, id)

      conn = get(conn, badge_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Badge"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, badge_path(conn, :create), badge: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Badge"
    end
  end

  describe "edit badge" do
    setup [:create_badge]

    test "renders form for editing chosen badge", %{conn: conn, badge: badge} do
      conn = get(conn, badge_path(conn, :edit, badge))
      assert html_response(conn, 200) =~ "Edit Badge"
    end
  end

  describe "update badge" do
    setup [:create_badge]

    test "redirects when data is valid", %{conn: conn, badge: badge} do
      conn = put(conn, badge_path(conn, :update, badge), badge: @update_attrs)
      assert redirected_to(conn) == badge_path(conn, :show, badge)

      conn = get(conn, badge_path(conn, :show, badge))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, badge: badge} do
      conn = put(conn, badge_path(conn, :update, badge), badge: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Badge"
    end
  end

  describe "delete badge" do
    setup [:create_badge]

    test "deletes chosen badge", %{conn: conn, badge: badge} do
      conn = delete(conn, badge_path(conn, :delete, badge))
      assert redirected_to(conn) == badge_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, badge_path(conn, :show, badge))
      end)
    end
  end

  defp create_badge(_) do
    badge = fixture(:badge)
    {:ok, badge: badge}
  end
end
