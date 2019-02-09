defmodule Stringhelper do
  def validate_alphanumeric(string) do
    return =
      if Regex.match?(~r/^[0-9A-Za-z]+$/, string) do
        {:ok, "correct"}
      else
        {:error, "contain forbidden character"}
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
