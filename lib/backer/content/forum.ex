defmodule Backer.Content.Forum do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forums" do
    field(:content, :string)
    field(:is_visible, :boolean, default: false)
    field(:like_count, :integer)
    field(:status, :string)
    field(:title, :string)
    field(:pledger_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, [:title, :content, :is_visible, :status, :like_count, :backer_id, :pledger_id])
    |> validate_required([:pledger_id, :backer_id, :title, :content])
    |> IO.inspect
  end
end
