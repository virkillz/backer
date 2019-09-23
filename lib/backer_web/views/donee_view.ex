defmodule BackerWeb.DoneeView do
  use BackerWeb, :view

  use Scrivener.HTML

  def topbar_active(conn, current_path) do
    if conn.request_path == current_path do
      " border-purple-600 text-purple-600 "
    else
      " border_transparent text-gray-600 "
    end
  end
end
