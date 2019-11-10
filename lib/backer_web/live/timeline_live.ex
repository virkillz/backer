defmodule BackerWeb.TimelineLive do
  use Phoenix.LiveView

  alias Backer.Content
  alias Backer.Account

  def render(assigns) do
    Phoenix.View.render(BackerWeb.BackerView, "home_timeline_live.html", assigns)
  end

  def mount(session, socket) do
    posts = Content.list_public_post(5) |> IO.inspect()

    new_socket =
      socket
      |> assign(backer: session.backer)
      |> assign(show_form?: false)
      |> assign(posts: posts)
      |> assign(mode: "text")
      |> assign(title: "")
      |> assign(content: "")
      |> add_donee(session.backer)

    {:ok, new_socket}
  end

  defp add_donee(socket, backer) do
    if backer.is_donee do
      donee = Account.get_donee(%{"username" => backer.username})
      assign(socket, donee: donee)
    else
      assign(socket, donee: nil)
    end
  end

  def handle_event("show-form", value, socket) do
    new_socket =
      socket
      |> assign(show_form?: true)

    {:noreply, new_socket}
  end

  def handle_event("close-form", value, socket) do
    new_socket =
      socket
      |> assign(show_form?: false)

    {:noreply, new_socket}
  end

  def handle_event("switch-mode", value, socket) do
    new_socket =
      socket
      |> assign(mode: value["mode"])

    {:noreply, new_socket}
  end

  def handle_event("toggle_like", value, socket) do
    is_liked? = Content.toggle_post_like(value["post-id"], socket.assigns.donee.backer.id)

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
      "donee_id" => socket.assigns.donee.id,
      "type" => socket.assigns.mode
    }

    IO.inspect(attrs)

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
