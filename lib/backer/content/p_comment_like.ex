defmodule Backer.Content.PCommentLike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pcomment_likes" do
    field(:pcomment_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(p_comment_like, attrs) do
    p_comment_like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
