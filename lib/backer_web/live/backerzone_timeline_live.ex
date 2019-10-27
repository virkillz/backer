defmodule BackerWeb.BackerzoneTimelineLive do
  use Phoenix.LiveView
  alias Backer.Content

  def render(assigns) do
    IO.inspect(assigns)

    Phoenix.View.render(BackerWeb.BackerView, "test.html", assigns)
  end

  def mount(session, socket) do
    timeline = Content.list_public_post(5)

    new_socket =
      socket
      |> assign(backer: session.backer)
      |> assign(random_donee: [])
      |> assign(timeline: timeline)
    {:ok, new_socket}
  end

  def handle_event("cobadeh", _value, socket) do



    {:noreply, assign(socket, deploy_step: "Creating GitHub org...")}
  end
end
