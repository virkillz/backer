defmodule BackerWeb.PostLikeControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:post_like) do
    {:ok, post_like} = Content.create_post_like(@create_attrs)
    post_like
  end

  describe "index" do
    test "lists all post_likes", %{conn: conn} do
      conn = get(conn, post_like_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Post likes"
    end
  end

  describe "new post_like" do
    test "renders form", %{conn: conn} do
      conn = get(conn, post_like_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post like"
    end
  end

  describe "create post_like" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, post_like_path(conn, :create), post_like: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == post_like_path(conn, :show, id)

      conn = get(conn, post_like_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post like"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, post_like_path(conn, :create), post_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post like"
    end
  end

  describe "edit post_like" do
    setup [:create_post_like]

    test "renders form for editing chosen post_like", %{conn: conn, post_like: post_like} do
      conn = get(conn, post_like_path(conn, :edit, post_like))
      assert html_response(conn, 200) =~ "Edit Post like"
    end
  end

  describe "update post_like" do
    setup [:create_post_like]

    test "redirects when data is valid", %{conn: conn, post_like: post_like} do
      conn = put(conn, post_like_path(conn, :update, post_like), post_like: @update_attrs)
      assert redirected_to(conn) == post_like_path(conn, :show, post_like)

      conn = get(conn, post_like_path(conn, :show, post_like))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, post_like: post_like} do
      conn = put(conn, post_like_path(conn, :update, post_like), post_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post like"
    end
  end

  describe "delete post_like" do
    setup [:create_post_like]

    test "deletes chosen post_like", %{conn: conn, post_like: post_like} do
      conn = delete(conn, post_like_path(conn, :delete, post_like))
      assert redirected_to(conn) == post_like_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, post_like_path(conn, :show, post_like))
      end)
    end
  end

  defp create_post_like(_) do
    post_like = fixture(:post_like)
    {:ok, post_like: post_like}
  end
end
