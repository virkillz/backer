defmodule BackerWeb.ForumLikeController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.ForumLike

  def index(conn, _params) do
    forum_like = Content.list_forum_like()
    render(conn, "index.html", forum_like: forum_like)
  end

  def new(conn, _params) do
    changeset = Content.change_forum_like(%ForumLike{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"forum_like" => forum_like_params}) do
    case Content.create_forum_like(forum_like_params) do
      {:ok, forum_like} ->
        conn
        |> put_flash(:info, "Forum like created successfully.")
        |> redirect(to: forum_like_path(conn, :show, forum_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    forum_like = Content.get_forum_like!(id)
    render(conn, "show.html", forum_like: forum_like)
  end

  def edit(conn, %{"id" => id}) do
    forum_like = Content.get_forum_like!(id)
    changeset = Content.change_forum_like(forum_like)
    render(conn, "edit.html", forum_like: forum_like, changeset: changeset)
  end

  def update(conn, %{"id" => id, "forum_like" => forum_like_params}) do
    forum_like = Content.get_forum_like!(id)

    case Content.update_forum_like(forum_like, forum_like_params) do
      {:ok, forum_like} ->
        conn
        |> put_flash(:info, "Forum like updated successfully.")
        |> redirect(to: forum_like_path(conn, :show, forum_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", forum_like: forum_like, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    forum_like = Content.get_forum_like!(id)
    {:ok, _forum_like} = Content.delete_forum_like(forum_like)

    conn
    |> put_flash(:info, "Forum like deleted successfully.")
    |> redirect(to: forum_like_path(conn, :index))
  end
end
