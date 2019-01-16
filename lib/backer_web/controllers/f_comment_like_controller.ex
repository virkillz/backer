defmodule BackerWeb.FCommentLikeController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.FCommentLike

  def index(conn, _params) do
    fcomment_like = Content.list_fcomment_like()
    render(conn, "index.html", fcomment_like: fcomment_like)
  end

  def new(conn, _params) do
    changeset = Content.change_f_comment_like(%FCommentLike{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"f_comment_like" => f_comment_like_params}) do
    case Content.create_f_comment_like(f_comment_like_params) do
      {:ok, f_comment_like} ->
        conn
        |> put_flash(:info, "F comment like created successfully.")
        |> redirect(to: f_comment_like_path(conn, :show, f_comment_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    f_comment_like = Content.get_f_comment_like!(id)
    render(conn, "show.html", f_comment_like: f_comment_like)
  end

  def edit(conn, %{"id" => id}) do
    f_comment_like = Content.get_f_comment_like!(id)
    changeset = Content.change_f_comment_like(f_comment_like)
    render(conn, "edit.html", f_comment_like: f_comment_like, changeset: changeset)
  end

  def update(conn, %{"id" => id, "f_comment_like" => f_comment_like_params}) do
    f_comment_like = Content.get_f_comment_like!(id)

    case Content.update_f_comment_like(f_comment_like, f_comment_like_params) do
      {:ok, f_comment_like} ->
        conn
        |> put_flash(:info, "F comment like updated successfully.")
        |> redirect(to: f_comment_like_path(conn, :show, f_comment_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", f_comment_like: f_comment_like, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    f_comment_like = Content.get_f_comment_like!(id)
    {:ok, _f_comment_like} = Content.delete_f_comment_like(f_comment_like)

    conn
    |> put_flash(:info, "F comment like deleted successfully.")
    |> redirect(to: f_comment_like_path(conn, :index))
  end
end
