defmodule BackerWeb.PostCommentController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Content.PostComment

  def index(conn, _params) do
    pcomments = Content.list_pcomments()
    render(conn, "index.html", pcomments: pcomments)
  end

  def new(conn, _params) do
    changeset = Content.change_post_comment(%PostComment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_comment" => post_comment_params}) do
    case Content.create_post_comment(post_comment_params) do
      {:ok, post_comment} ->
        conn
        |> put_flash(:info, "Post comment created successfully.")
        |> redirect(to: post_comment_path(conn, :show, post_comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_comment = Content.get_post_comment!(id)
    render(conn, "show.html", post_comment: post_comment)
  end

  def edit(conn, %{"id" => id}) do
    post_comment = Content.get_post_comment!(id)
    changeset = Content.change_post_comment(post_comment)
    render(conn, "edit.html", post_comment: post_comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post_comment" => post_comment_params}) do
    post_comment = Content.get_post_comment!(id)

    case Content.update_post_comment(post_comment, post_comment_params) do
      {:ok, post_comment} ->
        conn
        |> put_flash(:info, "Post comment updated successfully.")
        |> redirect(to: post_comment_path(conn, :show, post_comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post_comment: post_comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_comment = Content.get_post_comment!(id)
    {:ok, _post_comment} = Content.delete_post_comment(post_comment)

    conn
    |> put_flash(:info, "Post comment deleted successfully.")
    |> redirect(to: post_comment_path(conn, :index))
  end
end
