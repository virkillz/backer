defmodule BackerWeb.LayoutView do
  use BackerWeb, :view

  @exceptionpath ["/admin", "/dashboard"]

  def activate(path, href) do
    if path =~ href and !Enum.member?(@exceptionpath, href) do
      "active"
    else
      if path == href and Enum.member?(@exceptionpath, href) do
        "active"
      end
    end
  end

  # def render_layout(layout, assigns, do: content) do
  #  	render(layout, Map.put(assigns, :inner_layout, content))
  # end
end
