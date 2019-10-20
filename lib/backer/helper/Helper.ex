defmodule Backer.Helper do
  def imgix(img_url, options \\ %{}) do
    if String.contains?(img_url, "https://vkbacker.s3.amazonaws.com") do
      img_url
      |> String.replace("https://vkbacker.s3.amazonaws.com", "")
      |> Imgex.url(options)
    else
      if String.starts_with?(img_url, "/") do
        img_url
        # Imgex.proxy_url("http://alpha.backer.id/assets/images/bg/tuli.jpeg", options)
      else
        img_url
      end
    end
  end

  def upload_s3_helper(file) do
    file_uuid = Ecto.UUID.generate()
    image_filename = file.filename
    unique_filename = "#{file_uuid}-#{image_filename |> String.replace(" ", "_")}"
    {:ok, image_binary} = File.read(file.path)

    cond do
      not String.contains?(file.content_type, "image") ->
        "error"

      true ->
        bucket_name = System.get_env("BUCKET_NAME")

        image =
          ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
          |> ExAws.request!()

        "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"
    end
  end

  def verify_recaptcha(response) do
    req_body =
      URI.encode_query(%{
        "secret" => "6Lewj74UAAAAAD9440WMSi6ZsIppWhWGYieMLe0X",
        "response" => response
      })

    call_result =
      HTTPoison.post(
        "https://www.google.com/recaptcha/api/siteverify",
        req_body,
        %{"Content-Type" => "application/x-www-form-urlencoded"}
      )

    case call_result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"success" => true}} -> :ok
          _ -> :wrongcaptcha
        end

      _ ->
        :connerror
    end
  end
end
