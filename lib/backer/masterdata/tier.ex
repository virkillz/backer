defmodule Backer.Masterdata.Tier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tiers" do
    field(:amount, :integer)
    field(:description, :string)
    field(:title, :string)
    field(:pledger_id, :id)

    timestamps()
  end

  @doc false
  def changeset(tier, attrs) do
    tier
    |> cast(attrs, [:title, :description, :amount])
    |> validate_required([:title, :description, :amount])
  end
end
