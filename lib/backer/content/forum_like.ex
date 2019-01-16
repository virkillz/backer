defmodule Backer.Content.ForumLike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forum_like" do
    field(:forum_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(forum_like, attrs) do
    forum_like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
