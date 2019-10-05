defmodule Backer.Account.Metadata do
  use Ecto.Schema
  import Ecto.Changeset

  schema "metadatas" do
    field(:group, :string)
    field(:key, :string)
    field(:value_boolean, :boolean, default: false)
    field(:value_integer, :integer)
    field(:value_string, :string)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(metadata, attrs) do
    metadata
    |> cast(attrs, [:group, :key, :backer_id, :value_integer, :value_string, :value_boolean])
    |> validate_required([:key, :backer_id])
  end
end
