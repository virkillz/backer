defmodule Backer.Content.PostComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pcomments" do
    field(:content, :string)
    field(:post_id, :id)
    field(:pcomment_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(post_comment, attrs) do
    post_comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
