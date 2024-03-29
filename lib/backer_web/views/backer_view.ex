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

  def get_payment_name(method_id) do
    payment_method_detail = get_payment_method_detail(method_id)

    payment_method_detail.name
  end

  def get_payment_logo(method_id) do
    payment_method_detail = get_payment_method_detail(method_id)

    payment_method_detail.logo
  end

  def get_payment_method_detail(method_id) do
    Backer.Constant.default_payment_methods()
    |> Enum.filter(fn x -> x.id == method_id end)
    |> List.first()
  end

  def ago(datetime) do
    {:ok, relative_str} =
      DateTime.from_naive!(datetime, "Etc/UTC") |> Timex.format("{relative}", :relative)

    relative_str
  end

  def home_sidebar_active(conn, current_path) do
    if String.starts_with?(conn.request_path, current_path) do
      " bg-black font-semibold text-orange-500 "
    end
  end

  def sidebar_active(conn, current_path) do
    cond do
      current_path == "/backerzone/payment-history" &&
          String.starts_with?(conn.request_path, "/backerzone/invoice/") ->
        " font-semibold text-indigo-500 "

      conn.request_path == current_path ->
        " font-semibold text-indigo-500 "

      true ->
        " font-basex "
    end
  end
end
