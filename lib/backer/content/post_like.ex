defmodule Backer.Content.PostLike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_likes" do
    field(:post_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(post_like, attrs) do
    post_like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
