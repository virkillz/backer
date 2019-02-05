defmodule BackerWeb.DefaultController do
  use BackerWeb, :controller

  def page_404(conn, _params) do
    # activity = Logging.get_last_x_activity(100)
    render(conn, "page_404.html", layout: {BackerWeb.LayoutView, "default.html"})
  end
end
