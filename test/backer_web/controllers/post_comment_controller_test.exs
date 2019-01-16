defmodule BackerWeb.PostCommentControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:post_comment) do
    {:ok, post_comment} = Content.create_post_comment(@create_attrs)
    post_comment
  end

  describe "index" do
    test "lists all pcomments", %{conn: conn} do
      conn = get(conn, post_comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pcomments"
    end
  end

  describe "new post_comment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, post_comment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post comment"
    end
  end

  describe "create post_comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, post_comment_path(conn, :create), post_comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == post_comment_path(conn, :show, id)

      conn = get(conn, post_comment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, post_comment_path(conn, :create), post_comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post comment"
    end
  end

  describe "edit post_comment" do
    setup [:create_post_comment]

    test "renders form for editing chosen post_comment", %{conn: conn, post_comment: post_comment} do
      conn = get(conn, post_comment_path(conn, :edit, post_comment))
      assert html_response(conn, 200) =~ "Edit Post comment"
    end
  end

  describe "update post_comment" do
    setup [:create_post_comment]

    test "redirects when data is valid", %{conn: conn, post_comment: post_comment} do
      conn =
        put(conn, post_comment_path(conn, :update, post_comment), post_comment: @update_attrs)

      assert redirected_to(conn) == post_comment_path(conn, :show, post_comment)

      conn = get(conn, post_comment_path(conn, :show, post_comment))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post_comment: post_comment} do
      conn =
        put(conn, post_comment_path(conn, :update, post_comment), post_comment: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Post comment"
    end
  end

  describe "delete post_comment" do
    setup [:create_post_comment]

    test "deletes chosen post_comment", %{conn: conn, post_comment: post_comment} do
      conn = delete(conn, post_comment_path(conn, :delete, post_comment))
      assert redirected_to(conn) == post_comment_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, post_comment_path(conn, :show, post_comment))
      end)
    end
  end

  defp create_post_comment(_) do
    post_comment = fixture(:post_comment)
    {:ok, post_comment: post_comment}
  end
end
