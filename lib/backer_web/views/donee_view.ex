defmodule BackerWeb.DoneeView do
  use BackerWeb, :view

  use Scrivener.HTML

  def datetime_to_date(datetime) do
    "#{datetime.day} #{Stringhelper.number_to_month(datetime.month)} #{datetime.year}"
  end

  def topbar_active(conn, current_path) do
    if conn.request_path == current_path do
      " border-orange-500 "
    else
      " border_transparent "
    end
  end

  def sidebar_active(conn, current_path) do
    if conn.request_path == current_path do
      " border-orange-500 text-orange-500 "
    else
      " border-transparent text-gray-700 "
    end
  end
end
