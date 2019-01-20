defmodule Backer.Content.ForumComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fcomments" do
    field(:content, :string)
    field(:forum_id, :id)
    field(:reply_to, :id, [source: :fcomment_id])
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(forum_comment, attrs) do
    forum_comment
    |> cast(attrs, [:content, :forum_id, :backer_id])
    |> validate_required([:content, :forum_id, :backer_id])
  end
end
