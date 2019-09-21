defmodule Backer.Gamification.Badge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "badges" do
    field(:description, :string)
    field(:icon, :string)
    field(:title, :string)
    field(:donee_id, :id)

    timestamps()
  end

  @doc false
  def changeset(badge, attrs) do
    badge
    |> cast(attrs, [:title, :icon, :description, :donee_id])
    |> validate_required([:title])
  end
end
