defmodule BackerWeb.FCommentLikeControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:f_comment_like) do
    {:ok, f_comment_like} = Content.create_f_comment_like(@create_attrs)
    f_comment_like
  end

  describe "index" do
    test "lists all fcomment_like", %{conn: conn} do
      conn = get(conn, f_comment_like_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fcomment like"
    end
  end

  describe "new f_comment_like" do
    test "renders form", %{conn: conn} do
      conn = get(conn, f_comment_like_path(conn, :new))
      assert html_response(conn, 200) =~ "New F comment like"
    end
  end

  describe "create f_comment_like" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, f_comment_like_path(conn, :create), f_comment_like: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == f_comment_like_path(conn, :show, id)

      conn = get(conn, f_comment_like_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show F comment like"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, f_comment_like_path(conn, :create), f_comment_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "New F comment like"
    end
  end

  describe "edit f_comment_like" do
    setup [:create_f_comment_like]

    test "renders form for editing chosen f_comment_like", %{
      conn: conn,
      f_comment_like: f_comment_like
    } do
      conn = get(conn, f_comment_like_path(conn, :edit, f_comment_like))
      assert html_response(conn, 200) =~ "Edit F comment like"
    end
  end

  describe "update f_comment_like" do
    setup [:create_f_comment_like]

    test "redirects when data is valid", %{conn: conn, f_comment_like: f_comment_like} do
      conn =
        put(conn, f_comment_like_path(conn, :update, f_comment_like),
          f_comment_like: @update_attrs
        )

      assert redirected_to(conn) == f_comment_like_path(conn, :show, f_comment_like)

      conn = get(conn, f_comment_like_path(conn, :show, f_comment_like))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, f_comment_like: f_comment_like} do
      conn =
        put(conn, f_comment_like_path(conn, :update, f_comment_like),
          f_comment_like: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit F comment like"
    end
  end

  describe "delete f_comment_like" do
    setup [:create_f_comment_like]

    test "deletes chosen f_comment_like", %{conn: conn, f_comment_like: f_comment_like} do
      conn = delete(conn, f_comment_like_path(conn, :delete, f_comment_like))
      assert redirected_to(conn) == f_comment_like_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, f_comment_like_path(conn, :show, f_comment_like))
      end)
    end
  end

  defp create_f_comment_like(_) do
    f_comment_like = fixture(:f_comment_like)
    {:ok, f_comment_like: f_comment_like}
  end
end
