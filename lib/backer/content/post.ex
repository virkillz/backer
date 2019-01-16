defmodule Backer.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:content, :string)
    field(:featured_image, :string)
    field(:featured_link, :string)
    field(:featured_video, :string)
    field(:like_count, :integer)
    field(:min_tier, :integer)
    field(:title, :string)
    field(:pledger_id, :id)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :like_count,
      :title,
      :content,
      :min_tier,
      :featured_image,
      :featured_link,
      :featured_video
    ])
    |> validate_required([
      :like_count,
      :title,
      :content,
      :min_tier,
      :featured_image,
      :featured_link,
      :featured_video
    ])
  end
end
