defmodule Backer.Helper do
  def upload_s3_helper(file) do
    file_uuid = Ecto.UUID.generate()
    image_filename = file.filename
    unique_filename = "#{file_uuid}-#{image_filename}"
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
end
