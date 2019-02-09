defmodule BackerWeb.LayoutView do
  use BackerWeb, :view

  @exceptionpath "/admin"

  def activate(path, href) do
    if path =~ href and href != @exceptionpath do
      "active"
    end
  end

  # def render_layout(layout, assigns, do: content) do
  #  	render(layout, Map.put(assigns, :inner_layout, content))
  # end
end
