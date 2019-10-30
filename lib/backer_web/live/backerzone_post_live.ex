defmodule BackerWeb.BackerzonePostLive do
  use Phoenix.LiveView
  alias Backer.Content
  alias Backer.Content.PostComment

  def render(assigns) do
    Phoenix.View.render(BackerWeb.BackerView, "backerzone_post_live.html", assigns)
  end

  def mount(session, socket) do
    comments = Content.list_pcomments(%{"post_id" => session.post.id}) |> IO.inspect()
    changeset_comment = Content.change_post_comment(%PostComment{})

    new_socket =
      socket
      |> assign(backer: session.backer)
      |> assign(random_donee: [])
      |> assign(post: session.post)
      |> assign(comments: comments)
      |> assign(changeset_comment: changeset_comment)
      |> assign(comment_input: "")

    {:ok, new_socket}
  end

  def handle_event("send_comment", %{"post_comment" => post_params}, socket) do
    post_attrs =
      post_params
      |> Map.put("post_id", socket.assigns.post.id)
      |> Map.put("backer_id", socket.assigns.backer.id)

    new_comments =
      case Content.create_post_comment_multi(post_attrs) do
        {:ok, %{comment: comment}} ->
          [comment] ++ socket.assigns.comments

        reason ->
          socket.assigns.comments
      end

    new_socket = socket |> assign(comment_input: "") |> assign(comments: new_comments)
    {:noreply, new_socket}
  end
end
