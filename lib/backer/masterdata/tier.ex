defmodule Backer.Masterdata.Tier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tiers" do
    field(:amount, :integer)
    field(:description, :string)
    field(:title, :string)
    field(:donee_id, :id)

    timestamps()
  end

  @doc false
  def changeset(tier, attrs) do
    tier
    |> cast(attrs, [:title, :description, :amount, :donee_id])
    |> validate_required([:title, :description, :amount, :donee_id])
  end
end
