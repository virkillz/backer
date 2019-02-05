defmodule Backer.Content.PostComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pcomments" do
    field(:content, :string)
    # field(:pcomment_id, :id)
    # field(:backer_id, :id)

    belongs_to(:post, {"posts", Backer.Content.Post})
    belongs_to(:pcomment, {"pcomments", Backer.Content.PostComment})
    belongs_to(:backer, {"backers", Backer.Account.Backer})

    timestamps()
  end

  @doc false
  def changeset(post_comment, attrs) do
    post_comment
    |> cast(attrs, [:content, :post_id, :backer_id])
    |> validate_required([:content, :post_id, :backer_id])
  end
end
