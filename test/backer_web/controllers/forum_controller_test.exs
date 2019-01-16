defmodule BackerWeb.ForumControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{
    content: "some content",
    is_visible: true,
    like_count: 42,
    status: "some status",
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    is_visible: false,
    like_count: 43,
    status: "some updated status",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, is_visible: nil, like_count: nil, status: nil, title: nil}

  def fixture(:forum) do
    {:ok, forum} = Content.create_forum(@create_attrs)
    forum
  end

  describe "index" do
    test "lists all forums", %{conn: conn} do
      conn = get(conn, forum_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Forums"
    end
  end

  describe "new forum" do
    test "renders form", %{conn: conn} do
      conn = get(conn, forum_path(conn, :new))
      assert html_response(conn, 200) =~ "New Forum"
    end
  end

  describe "create forum" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, forum_path(conn, :create), forum: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == forum_path(conn, :show, id)

      conn = get(conn, forum_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Forum"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, forum_path(conn, :create), forum: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Forum"
    end
  end

  describe "edit forum" do
    setup [:create_forum]

    test "renders form for editing chosen forum", %{conn: conn, forum: forum} do
      conn = get(conn, forum_path(conn, :edit, forum))
      assert html_response(conn, 200) =~ "Edit Forum"
    end
  end

  describe "update forum" do
    setup [:create_forum]

    test "redirects when data is valid", %{conn: conn, forum: forum} do
      conn = put(conn, forum_path(conn, :update, forum), forum: @update_attrs)
      assert redirected_to(conn) == forum_path(conn, :show, forum)

      conn = get(conn, forum_path(conn, :show, forum))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, forum: forum} do
      conn = put(conn, forum_path(conn, :update, forum), forum: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Forum"
    end
  end

  describe "delete forum" do
    setup [:create_forum]

    test "deletes chosen forum", %{conn: conn, forum: forum} do
      conn = delete(conn, forum_path(conn, :delete, forum))
      assert redirected_to(conn) == forum_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, forum_path(conn, :show, forum))
      end)
    end
  end

  defp create_forum(_) do
    forum = fixture(:forum)
    {:ok, forum: forum}
  end
end
