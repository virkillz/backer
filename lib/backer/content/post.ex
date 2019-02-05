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

    has_many(:pcomment, Backer.Content.PostComment)

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
      :featured_video,
      :pledger_id
    ])
    |> validate_required([:pledger_id, :content, :min_tier])
    |> validate_only_one
    |> IO.inspect()
  end

  def validate_only_one(changeset) do
    changeset |> IO.inspect()
    featured_link = get_field(changeset, :featured_link) |> IO.inspect()
    featured_video = get_field(changeset, :featured_video) |> IO.inspect()
    featured_image = get_field(changeset, :featured_image) |> IO.inspect()

    cond do
      featured_image != nil and featured_link == nil and featured_video == nil ->
        changeset

      featured_image == nil and featured_link != nil and featured_video == nil ->
        changeset

      featured_image == nil and featured_link == nil and featured_video != nil ->
        changeset

      featured_image == nil and featured_link == nil and featured_video == nil ->
        changeset

      true ->
        changeset
        |> add_error(:featured_video, "You can only have one featured")
        |> add_error(:featured_image, "You can only have one featured")
        |> add_error(:featured_link, "You can only have one featured")
    end
  end
end
