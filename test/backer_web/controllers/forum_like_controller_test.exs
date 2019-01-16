defmodule BackerWeb.ForumLikeControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:forum_like) do
    {:ok, forum_like} = Content.create_forum_like(@create_attrs)
    forum_like
  end

  describe "index" do
    test "lists all forum_like", %{conn: conn} do
      conn = get(conn, forum_like_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Forum like"
    end
  end

  describe "new forum_like" do
    test "renders form", %{conn: conn} do
      conn = get(conn, forum_like_path(conn, :new))
      assert html_response(conn, 200) =~ "New Forum like"
    end
  end

  describe "create forum_like" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, forum_like_path(conn, :create), forum_like: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == forum_like_path(conn, :show, id)

      conn = get(conn, forum_like_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Forum like"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, forum_like_path(conn, :create), forum_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Forum like"
    end
  end

  describe "edit forum_like" do
    setup [:create_forum_like]

    test "renders form for editing chosen forum_like", %{conn: conn, forum_like: forum_like} do
      conn = get(conn, forum_like_path(conn, :edit, forum_like))
      assert html_response(conn, 200) =~ "Edit Forum like"
    end
  end

  describe "update forum_like" do
    setup [:create_forum_like]

    test "redirects when data is valid", %{conn: conn, forum_like: forum_like} do
      conn = put(conn, forum_like_path(conn, :update, forum_like), forum_like: @update_attrs)
      assert redirected_to(conn) == forum_like_path(conn, :show, forum_like)

      conn = get(conn, forum_like_path(conn, :show, forum_like))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, forum_like: forum_like} do
      conn = put(conn, forum_like_path(conn, :update, forum_like), forum_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Forum like"
    end
  end

  describe "delete forum_like" do
    setup [:create_forum_like]

    test "deletes chosen forum_like", %{conn: conn, forum_like: forum_like} do
      conn = delete(conn, forum_like_path(conn, :delete, forum_like))
      assert redirected_to(conn) == forum_like_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, forum_like_path(conn, :show, forum_like))
      end)
    end
  end

  defp create_forum_like(_) do
    forum_like = fixture(:forum_like)
    {:ok, forum_like: forum_like}
  end
end
