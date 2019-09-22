defmodule BackerWeb.BackerView do
  use BackerWeb, :view

  use Scrivener.HTML

  def stringify(x) do
    case x do
      1 -> "January"
      2 -> "February"
      3 -> "March"
      4 -> "April"
      5 -> "May"
      6 -> "June"
      7 -> "July"
      8 -> "August"
      9 -> "September"
      10 -> "October"
      11 -> "November"
      12 -> "December"
    end
  end

  def ago(datetime) do
    {:ok, relative_str} =
      DateTime.from_naive!(datetime, "Etc/UTC") |> Timex.format("{relative}", :relative)

    relative_str
  end

  def sidebar_active(conn, current_path) do
    IO.inspect(conn.request_path)

    if conn.request_path == current_path do
      " font-semibold bg-purple-200 text-purple-700 "
    else
      " font-base text-gray-700 "
    end
  end
end
