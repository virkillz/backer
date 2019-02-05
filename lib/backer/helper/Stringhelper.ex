defmodule Stringhelper do
  def validate_alphanumeric(string) do
    return =
      if Regex.match?(~r/^[0-9A-Za-z]+$/, string) do
        {:ok, "correct"}
      else
        {:error, "contain forbidden character"}
      end
  end

  def validate_alphanumeric_and_space(string) do
    return =
      if Regex.match?(~r/^[a-z\d\-_\s]+$/i, string) do
        {:ok, "correct"}
      else
        {:error, "contain forbidden character"}
      end
  end
end
