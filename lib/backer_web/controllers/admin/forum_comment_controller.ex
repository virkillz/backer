defmodule BackerWeb.ForumCommentController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Content
  alias Backer.Content.ForumComment

  def index(conn, _params) do
    fcomments = Content.list_fcomments()
    render(conn, "index.html", fcomments: fcomments)
  end

  def new(conn, _params) do
    changeset = Content.change_forum_comment(%ForumComment{})
    render(conn, "new.html", changeset: changeset)
  end

  def newcomment(conn, %{"forumid" => forumid}) do
    backers = Account.list_backers()
    changeset = Content.change_forum_comment(%ForumComment{})
    render(conn, "new.html", changeset: changeset, backers: backers, id: forumid)
  end

  def create(conn, %{"forum_comment" => forum_comment_params}) do
    forum_comment_params

    case Content.create_forum_comment(forum_comment_params) do
      {:ok, forum_comment} ->
        conn
        |> put_flash(:info, "Forum comment created successfully.")
        |> redirect(to: Router.forum_comment_path(conn, :show, forum_comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    forum_comment = Content.get_forum_comment!(id)
    render(conn, "show.html", forum_comment: forum_comment)
  end

  def edit(conn, %{"id" => id}) do
    backers = Account.list_backers()
    forum_comment = Content.get_forum_comment!(id)
    changeset = Content.change_forum_comment(forum_comment)

    render(conn, "edit.html",
      forum_comment: forum_comment,
      changeset: changeset,
      backers: backers,
      id: forum_comment.forum_id
    )
  end

  def update(conn, %{"id" => id, "forum_comment" => forum_comment_params}) do
    forum_comment = Content.get_forum_comment!(id)

    case Content.update_forum_comment(forum_comment, forum_comment_params) do
      {:ok, forum_comment} ->
        conn
        |> put_flash(:info, "Forum comment updated successfully.")
        |> redirect(to: Router.forum_comment_path(conn, :show, forum_comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", forum_comment: forum_comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    forum_comment = Content.get_forum_comment!(id)
    {:ok, _forum_comment} = Content.delete_forum_comment(forum_comment)

    conn
    |> put_flash(:info, "Forum comment deleted successfully.")
    |> redirect(to: Router.forum_path(conn, :show, forum_comment.forum_id))
  end
end
