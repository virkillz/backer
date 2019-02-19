defmodule BackerWeb.BackershowController do
  use BackerWeb, :controller

  alias Backer.Content

  def show_post(conn, %{"id" => id}) do
    {posts , comments} = Content.get_post(%{"id" => id}) |> IO.inspect
    backer = conn.assigns.current_backer

    post = Map.put(posts, :comments, comments) |> IO.inspect

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page400))

      _ ->
        conn
        |> render("front_timeline_show.html",
          backer: backer,
          owner: true,
          menu: :timeline,
          post: post,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

end
