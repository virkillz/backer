defmodule BackerWeb.PostLikeController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.PostLike

  def index(conn, _params) do
    post_likes = Content.list_post_likes()
    render(conn, "index.html", post_likes: post_likes)
  end

  def new(conn, _params) do
    changeset = Content.change_post_like(%PostLike{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_like" => post_like_params}) do
    case Content.create_post_like(post_like_params) do
      {:ok, post_like} ->
        conn
        |> put_flash(:info, "Post like created successfully.")
        |> redirect(to: post_like_path(conn, :show, post_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_like = Content.get_post_like!(id)
    render(conn, "show.html", post_like: post_like)
  end

  def edit(conn, %{"id" => id}) do
    post_like = Content.get_post_like!(id)
    changeset = Content.change_post_like(post_like)
    render(conn, "edit.html", post_like: post_like, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post_like" => post_like_params}) do
    post_like = Content.get_post_like!(id)

    case Content.update_post_like(post_like, post_like_params) do
      {:ok, post_like} ->
        conn
        |> put_flash(:info, "Post like updated successfully.")
        |> redirect(to: post_like_path(conn, :show, post_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post_like: post_like, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_like = Content.get_post_like!(id)
    {:ok, _post_like} = Content.delete_post_like(post_like)

    conn
    |> put_flash(:info, "Post like deleted successfully.")
    |> redirect(to: post_like_path(conn, :index))
  end
end
