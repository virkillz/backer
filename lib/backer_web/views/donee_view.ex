defmodule BackerWeb.DoneeView do
  use BackerWeb, :view

  use Scrivener.HTML

  def datetime_to_date(datetime) do
    "#{datetime.day} #{Stringhelper.number_to_month(datetime.month)} #{datetime.year}"
  end

  def topbar_active(conn, current_path) do
    if conn.request_path == current_path do
      " font-semiboldx border-orange-500 "
    else
      " font-basex border_transparent "
    end
  end

  def sidebar_active(conn, current_path) do
    if conn.request_path == current_path do
      " text-orange-500 "
    else
      " text-gray-600 "
    end
  end
end
