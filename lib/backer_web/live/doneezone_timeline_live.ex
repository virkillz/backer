defmodule BackerWeb.DoneezoneTimelineLive do
  use Phoenix.LiveView

  alias Backer.Content

  def render(assigns) do
    Phoenix.View.render(BackerWeb.DoneeView, "doneezone_timeline_live.html", assigns)
  end

  def mount(session, socket) do
    posts = Content.list_own_posts(session.donee_info.id, session.donee_info.backer.id, 10, 0)

    new_socket =
      socket
      |> assign(backer_info: session.donee_info.backer)
      |> assign(donee_info: session.donee_info)
      |> assign(mode: "text")
      |> assign(title: "")
      |> assign(content: "")
      |> assign(posts: posts)

    {:ok, new_socket}
  end

  def handle_event("switch-mode", value, socket) do
    new_socket =
      socket
      |> assign(mode: value["mode"])

    {:noreply, new_socket}
  end

  def handle_event("toggle_like", value, socket) do
    is_liked? = Content.toggle_post_like(value["post-id"], socket.assigns.donee_info.backer.id)

    new_socket =
      assign(socket,
        posts: like_post(socket.assigns.posts, String.to_integer(value["post-id"]), is_liked?)
      )

    {:noreply, new_socket}
  end

  def handle_event("post", value, socket) do
    attrs = %{
      "title" => value["title"],
      "content" => value["content"],
      "min_tier" => value["min-tier"],
      "donee_id" => socket.assigns.donee_info.id,
      "type" => socket.assigns.mode
    }

    new_posts =
      case Content.create_post(attrs) do
        {:ok, new_post} -> [new_post] ++ socket.assigns.posts
        {:error, _} -> socket.assigns.posts
      end

    new_socket =
      socket
      |> assign(title: "")
      |> assign(content: "")
      |> assign(posts: new_posts)

    {:noreply, new_socket}
  end

  defp like_post(posts, id, is_liked?) do
    Enum.map(posts, fn x -> if x.id == id, do: Map.put(x, :is_liked?, is_liked?) end)
  end
end
