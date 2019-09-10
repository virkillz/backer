defmodule BackerWeb.PCommentLikeController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.PCommentLike

  def index(conn, _params) do
    pcomment_likes = Content.list_pcomment_likes()
    render(conn, "index.html", pcomment_likes: pcomment_likes)
  end

  def new(conn, _params) do
    changeset = Content.change_p_comment_like(%PCommentLike{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"p_comment_like" => p_comment_like_params}) do
    case Content.create_p_comment_like(p_comment_like_params) do
      {:ok, p_comment_like} ->
        conn
        |> put_flash(:info, "P comment like created successfully.")
        |> redirect(to: Router.p_comment_like_path(conn, :show, p_comment_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    p_comment_like = Content.get_p_comment_like!(id)
    render(conn, "show.html", p_comment_like: p_comment_like)
  end

  def edit(conn, %{"id" => id}) do
    p_comment_like = Content.get_p_comment_like!(id)
    changeset = Content.change_p_comment_like(p_comment_like)
    render(conn, "edit.html", p_comment_like: p_comment_like, changeset: changeset)
  end

  def update(conn, %{"id" => id, "p_comment_like" => p_comment_like_params}) do
    p_comment_like = Content.get_p_comment_like!(id)

    case Content.update_p_comment_like(p_comment_like, p_comment_like_params) do
      {:ok, p_comment_like} ->
        conn
        |> put_flash(:info, "P comment like updated successfully.")
        |> redirect(to: Router.p_comment_like_path(conn, :show, p_comment_like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", p_comment_like: p_comment_like, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    p_comment_like = Content.get_p_comment_like!(id)
    {:ok, _p_comment_like} = Content.delete_p_comment_like(p_comment_like)

    conn
    |> put_flash(:info, "P comment like deleted successfully.")
    |> redirect(to: Router.p_comment_like_path(conn, :index))
  end
end
