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

  def sidebar_active(conn, current_path) do
    if conn.request_path == current_path do
      "font-semibold bg-purple-200 text-purple-700 "
    else
      "text-gray-700 "
    end
  end
end
