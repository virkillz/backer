defmodule BackerWeb.PCommentLikeControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:p_comment_like) do
    {:ok, p_comment_like} = Content.create_p_comment_like(@create_attrs)
    p_comment_like
  end

  describe "index" do
    test "lists all pcomment_likes", %{conn: conn} do
      conn = get(conn, p_comment_like_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pcomment likes"
    end
  end

  describe "new p_comment_like" do
    test "renders form", %{conn: conn} do
      conn = get(conn, p_comment_like_path(conn, :new))
      assert html_response(conn, 200) =~ "New P comment like"
    end
  end

  describe "create p_comment_like" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, p_comment_like_path(conn, :create), p_comment_like: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == p_comment_like_path(conn, :show, id)

      conn = get(conn, p_comment_like_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show P comment like"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, p_comment_like_path(conn, :create), p_comment_like: @invalid_attrs)
      assert html_response(conn, 200) =~ "New P comment like"
    end
  end

  describe "edit p_comment_like" do
    setup [:create_p_comment_like]

    test "renders form for editing chosen p_comment_like", %{
      conn: conn,
      p_comment_like: p_comment_like
    } do
      conn = get(conn, p_comment_like_path(conn, :edit, p_comment_like))
      assert html_response(conn, 200) =~ "Edit P comment like"
    end
  end

  describe "update p_comment_like" do
    setup [:create_p_comment_like]

    test "redirects when data is valid", %{conn: conn, p_comment_like: p_comment_like} do
      conn =
        put(conn, p_comment_like_path(conn, :update, p_comment_like),
          p_comment_like: @update_attrs
        )

      assert redirected_to(conn) == p_comment_like_path(conn, :show, p_comment_like)

      conn = get(conn, p_comment_like_path(conn, :show, p_comment_like))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, p_comment_like: p_comment_like} do
      conn =
        put(conn, p_comment_like_path(conn, :update, p_comment_like),
          p_comment_like: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit P comment like"
    end
  end

  describe "delete p_comment_like" do
    setup [:create_p_comment_like]

    test "deletes chosen p_comment_like", %{conn: conn, p_comment_like: p_comment_like} do
      conn = delete(conn, p_comment_like_path(conn, :delete, p_comment_like))
      assert redirected_to(conn) == p_comment_like_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, p_comment_like_path(conn, :show, p_comment_like))
      end)
    end
  end

  defp create_p_comment_like(_) do
    p_comment_like = fixture(:p_comment_like)
    {:ok, p_comment_like: p_comment_like}
  end
end
