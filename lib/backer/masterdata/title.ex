defmodule Backer.Masterdata.Title do
  use Ecto.Schema
  import Ecto.Changeset

  schema "titles" do
    field(:description, :string)
    field(:is_active, :boolean, default: false)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:name, :description, :is_active])
    |> validate_required([:name])
  end
end
