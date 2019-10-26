defmodule BackerWeb.TestLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    IO.inspect(assigns)

    Phoenix.View.render(BackerWeb.PublicView, "test.html", assigns)
  end

  def mount(session, socket) do
    new_socket =
      socket
      |> assign(deploy_step: "mbul")
      |> assign(backer: session.backer)
      |> assign(my_donee_list: [])
      |> assign(random_donee: [])
    {:ok, new_socket}
  end

  def handle_event("cobadeh", _value, socket) do



    {:noreply, assign(socket, deploy_step: "Creating GitHub org...")}
  end
end
