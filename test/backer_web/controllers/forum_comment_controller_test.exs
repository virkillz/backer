defmodule BackerWeb.ForumCommentControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:forum_comment) do
    {:ok, forum_comment} = Content.create_forum_comment(@create_attrs)
    forum_comment
  end

  describe "index" do
    test "lists all fcomments", %{conn: conn} do
      conn = get(conn, forum_comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fcomments"
    end
  end

  describe "new forum_comment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, forum_comment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Forum comment"
    end
  end

  describe "create forum_comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, forum_comment_path(conn, :create), forum_comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == forum_comment_path(conn, :show, id)

      conn = get(conn, forum_comment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Forum comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, forum_comment_path(conn, :create), forum_comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Forum comment"
    end
  end

  describe "edit forum_comment" do
    setup [:create_forum_comment]

    test "renders form for editing chosen forum_comment", %{
      conn: conn,
      forum_comment: forum_comment
    } do
      conn = get(conn, forum_comment_path(conn, :edit, forum_comment))
      assert html_response(conn, 200) =~ "Edit Forum comment"
    end
  end

  describe "update forum_comment" do
    setup [:create_forum_comment]

    test "redirects when data is valid", %{conn: conn, forum_comment: forum_comment} do
      conn =
        put(conn, forum_comment_path(conn, :update, forum_comment), forum_comment: @update_attrs)

      assert redirected_to(conn) == forum_comment_path(conn, :show, forum_comment)

      conn = get(conn, forum_comment_path(conn, :show, forum_comment))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, forum_comment: forum_comment} do
      conn =
        put(conn, forum_comment_path(conn, :update, forum_comment), forum_comment: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Forum comment"
    end
  end

  describe "delete forum_comment" do
    setup [:create_forum_comment]

    test "deletes chosen forum_comment", %{conn: conn, forum_comment: forum_comment} do
      conn = delete(conn, forum_comment_path(conn, :delete, forum_comment))
      assert redirected_to(conn) == forum_comment_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, forum_comment_path(conn, :show, forum_comment))
      end)
    end
  end

  defp create_forum_comment(_) do
    forum_comment = fixture(:forum_comment)
    {:ok, forum_comment: forum_comment}
  end
end
