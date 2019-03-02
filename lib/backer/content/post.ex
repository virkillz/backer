defmodule Backer.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:content, :string)
    field(:featured_image, :string)
    field(:featured_link, :string)
    field(:featured_video, :string)
    field(:like_count, :integer, default: 0)
    field(:comment_count, :integer)
    field(:min_tier, :integer)
    field(:title, :string)
    field(:type, :string)
    field(:publish_status, :string, default: "draft")

    has_many(:pcomment, Backer.Content.PostComment)
    belongs_to(:pledger, Backer.Account.Pledger)

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
      :comment_count,
      :like_count,
      :featured_image,
      :featured_link,
      :featured_video,
      :pledger_id,
      :type,
      :publish_status
    ])
    |> validate_required([:pledger_id, :title, :content, :min_tier])
    |> validate_only_one
  end

  def validate_only_one(changeset) do
    featured_link = get_field(changeset, :featured_link)
    featured_video = get_field(changeset, :featured_video)
    featured_image = get_field(changeset, :featured_image)

    cond do
      featured_image != nil and featured_link == nil and featured_video == nil ->
        changeset |> change(type: "image")

      featured_image == nil and featured_link != nil and featured_video == nil ->
        changeset |> change(type: "link")

      featured_image == nil and featured_link == nil and featured_video != nil ->
        changeset |> change(type: "video")

      featured_image == nil and featured_link == nil and featured_video == nil ->
        changeset |> change(type: "text")

      true ->
        changeset
        |> add_error(:featured_video, "You can only have one featured")
        |> add_error(:featured_image, "You can only have one featured")
        |> add_error(:featured_link, "You can only have one featured")
    end
  end
end
