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

  def meta_tags(attrs_list) do
    Enum.map(attrs_list, &meta_tag/1)
  end

  def meta_tag(attrs) do
    tag(:meta, Enum.into(attrs, []))
  end

  def count_notification(conn) do
    Backer.Content.count_notification(conn.assigns.backer.id)
  end

  # def render_layout(layout, assigns, do: content) do
  #  	render(layout, Map.put(assigns, :inner_layout, content))
  # end
end
