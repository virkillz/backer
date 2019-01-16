defmodule BackerWeb.PointControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Gamification

  @create_attrs %{point: 42, refference: 42, type: "some type"}
  @update_attrs %{point: 43, refference: 43, type: "some updated type"}
  @invalid_attrs %{point: nil, refference: nil, type: nil}

  def fixture(:point) do
    {:ok, point} = Gamification.create_point(@create_attrs)
    point
  end

  describe "index" do
    test "lists all points", %{conn: conn} do
      conn = get(conn, point_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Points"
    end
  end

  describe "new point" do
    test "renders form", %{conn: conn} do
      conn = get(conn, point_path(conn, :new))
      assert html_response(conn, 200) =~ "New Point"
    end
  end

  describe "create point" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, point_path(conn, :create), point: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == point_path(conn, :show, id)

      conn = get(conn, point_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Point"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, point_path(conn, :create), point: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Point"
    end
  end

  describe "edit point" do
    setup [:create_point]

    test "renders form for editing chosen point", %{conn: conn, point: point} do
      conn = get(conn, point_path(conn, :edit, point))
      assert html_response(conn, 200) =~ "Edit Point"
    end
  end

  describe "update point" do
    setup [:create_point]

    test "redirects when data is valid", %{conn: conn, point: point} do
      conn = put(conn, point_path(conn, :update, point), point: @update_attrs)
      assert redirected_to(conn) == point_path(conn, :show, point)

      conn = get(conn, point_path(conn, :show, point))
      assert html_response(conn, 200) =~ "some updated type"
    end

    test "renders errors when data is invalid", %{conn: conn, point: point} do
      conn = put(conn, point_path(conn, :update, point), point: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Point"
    end
  end

  describe "delete point" do
    setup [:create_point]

    test "deletes chosen point", %{conn: conn, point: point} do
      conn = delete(conn, point_path(conn, :delete, point))
      assert redirected_to(conn) == point_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, point_path(conn, :show, point))
      end)
    end
  end

  defp create_point(_) do
    point = fixture(:point)
    {:ok, point: point}
  end
end
