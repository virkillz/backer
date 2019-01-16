defmodule BackerWeb.TitleControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Masterdata

  @create_attrs %{description: "some description", is_active: true, name: "some name"}
  @update_attrs %{
    description: "some updated description",
    is_active: false,
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, is_active: nil, name: nil}

  def fixture(:title) do
    {:ok, title} = Masterdata.create_title(@create_attrs)
    title
  end

  describe "index" do
    test "lists all titles", %{conn: conn} do
      conn = get(conn, title_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Titles"
    end
  end

  describe "new title" do
    test "renders form", %{conn: conn} do
      conn = get(conn, title_path(conn, :new))
      assert html_response(conn, 200) =~ "New Title"
    end
  end

  describe "create title" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, title_path(conn, :create), title: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == title_path(conn, :show, id)

      conn = get(conn, title_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, title_path(conn, :create), title: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Title"
    end
  end

  describe "edit title" do
    setup [:create_title]

    test "renders form for editing chosen title", %{conn: conn, title: title} do
      conn = get(conn, title_path(conn, :edit, title))
      assert html_response(conn, 200) =~ "Edit Title"
    end
  end

  describe "update title" do
    setup [:create_title]

    test "redirects when data is valid", %{conn: conn, title: title} do
      conn = put(conn, title_path(conn, :update, title), title: @update_attrs)
      assert redirected_to(conn) == title_path(conn, :show, title)

      conn = get(conn, title_path(conn, :show, title))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, title: title} do
      conn = put(conn, title_path(conn, :update, title), title: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Title"
    end
  end

  describe "delete title" do
    setup [:create_title]

    test "deletes chosen title", %{conn: conn, title: title} do
      conn = delete(conn, title_path(conn, :delete, title))
      assert redirected_to(conn) == title_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, title_path(conn, :show, title))
      end)
    end
  end

  defp create_title(_) do
    title = fixture(:title)
    {:ok, title: title}
  end
end
