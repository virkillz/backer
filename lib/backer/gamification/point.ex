defmodule Backer.Gamification.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field(:point, :integer)
    field(:refference, :integer)
    field(:type, :string)
    field(:backer_id, :id)
    field(:donee_id, :id)

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:point, :type, :refference])
    |> validate_required([:point, :type, :refference])
  end
end
