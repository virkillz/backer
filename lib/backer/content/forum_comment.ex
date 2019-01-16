defmodule Backer.Content.ForumComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fcomments" do
    field(:content, :string)
    field(:forum_id, :id)
    field(:reply_to, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(forum_comment, attrs) do
    forum_comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
