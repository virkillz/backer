defmodule Backer.Content.FCommentLike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fcomment_like" do
    field(:fcomment_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(f_comment_like, attrs) do
    f_comment_like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
