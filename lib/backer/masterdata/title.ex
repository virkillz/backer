defmodule Backer.Masterdata.Title do
  use Ecto.Schema
  import Ecto.Changeset

  schema "titles" do
    field(:description, :string)
    field(:is_active, :boolean, default: true)
    field(:name, :string)
    field(:default_background, :string)

    timestamps()
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:name, :default_background, :description, :is_active])
    |> validate_required([:name])
  end
end
