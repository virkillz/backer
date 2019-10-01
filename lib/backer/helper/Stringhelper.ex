defmodule Stringhelper do
  def validate_alphanumeric(string) do
    return =
      if Regex.match?(~r/^[0-9A-Za-z]+$/, string) do
        {:ok, "correct"}
      else
        {:error, "contain forbidden character"}
      end
  end

  def accepted_images_mime?(format) do
    accepted_mime_types = [
      "image/png",
      "image/bmp",
      "image/gif",
      "image/svg+xml",
      "image/jpeg",
      "image/tiff",
      "image/webp"
    ]

    Enum.member?(accepted_mime_types, format)
  end

  def get_public_id_cloudinary!(url_image) do
    [_a, b, _c] = Regex.run(~r/(\w+)(\.\w+)+(?!.*(\w+)(\.\w+)+)/, url_image)
    b
  end

  def is_cloudinary_link?(url_image) do
    case Regex.run(~r/(\w+)(\.\w+)+(?!.*(\w+)(\.\w+)+)/, url_image) do
      [_a, b, _c] -> {:ok, b}
      _other -> {:error, "doesn't seems like cloudinary url"}
    end
  end

  def avatar(url_image, width) do
    # detect if its a cloudinary link. if not, bypass.
    case is_cloudinary_link?(url_image) do
      {:ok, id} ->
        "https://" <>
          Cloudex.Url.for(id, %{width: width, height: width, crop: "thumb", round: "max"})

      _other ->
        url_image
    end
  end

  def number_to_month(x) do
    stringify(x)
  end

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

  def format_thousand(integer, conn) do
    locale = Plug.Conn.get_session(conn, :locale)

    case locale do
      nil ->
        Number.Delimit.number_to_delimited(integer, delimiter: ",", separator: ".", precision: 0)

      "id" ->
        Number.Delimit.number_to_delimited(integer, delimiter: ",", separator: ".", precision: 0)

      "en" ->
        Number.Delimit.number_to_delimited(integer, delimiter: ".", separator: ",")

      _other ->
        Number.Delimit.number_to_delimited(integer, delimiter: ".", separator: ",")
    end
  end

  def format_thousand(integer) do
    integer
    |> Integer.to_char_list()
    |> Enum.reverse()
    |> Enum.chunk(3, 3, [])
    |> Enum.join(",")
    |> String.reverse()
  end

  def validate_alphanumeric_and_space(string) do
    if string == nil do
      {:error, "Cannot be empty"}
    else
      if Regex.match?(~r/^[a-z\d\-_\s]+$/i, string) do
        {:ok, "correct"}
      else
        {:error, "contain forbidden character"}
      end
    end
  end
end
