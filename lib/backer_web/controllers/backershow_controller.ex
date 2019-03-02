defmodule BackerWeb.BackershowController do
  use BackerWeb, :controller

  alias Backer.Content

  def show_post(conn, %{"id" => post_id}) do
    backer = conn.assigns.current_backer
    {posts, comments} = Content.get_post(%{"id" => post_id})

    is_post_liked = Content.is_post_liked?(post_id, backer.id)

    comments_ids = (comments |> Enum.map(fn x -> x.id end) )
    list_liked_comments = Content.list_liked_comments(comments_ids, backer.id)    

    post = Map.put(posts, :comments, comments) |> Map.put(:current_avatar, backer.avatar)

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page400))

      _ ->
        conn
        |> render("front_timeline_show.html",
          backer: backer,
          owner: true,
          is_post_liked: is_post_liked,
          list_liked_comments: list_liked_comments,
          menu: :timeline,
          post: post,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end
end
