defmodule BackerWeb.TestLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="bg-red-200">
      <div>
        <%= @deploy_step %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
