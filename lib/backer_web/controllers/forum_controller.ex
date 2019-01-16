defmodule BackerWeb.ForumController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.Forum

  def index(conn, _params) do
    forums = Content.list_forums()
    render(conn, "index.html", forums: forums)
  end

  def new(conn, _params) do
    changeset = Content.change_forum(%Forum{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"forum" => forum_params}) do
    case Content.create_forum(forum_params) do
      {:ok, forum} ->
        conn
        |> put_flash(:info, "Forum created successfully.")
        |> redirect(to: forum_path(conn, :show, forum))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    forum = Content.get_forum!(id)
    render(conn, "show.html", forum: forum)
  end

  def edit(conn, %{"id" => id}) do
    forum = Content.get_forum!(id)
    changeset = Content.change_forum(forum)
    render(conn, "edit.html", forum: forum, changeset: changeset)
  end

  def update(conn, %{"id" => id, "forum" => forum_params}) do
    forum = Content.get_forum!(id)

    case Content.update_forum(forum, forum_params) do
      {:ok, forum} ->
        conn
        |> put_flash(:info, "Forum updated successfully.")
        |> redirect(to: forum_path(conn, :show, forum))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", forum: forum, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    forum = Content.get_forum!(id)
    {:ok, _forum} = Content.delete_forum(forum)

    conn
    |> put_flash(:info, "Forum deleted successfully.")
    |> redirect(to: forum_path(conn, :index))
  end
end
