defmodule Backer.Gamification.BadgeMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "badge_members" do
    field(:award_date, :date)
    field(:backer_id, :id)
    field(:badge_id, :id)

    timestamps()
  end

  @doc false
  def changeset(badge_member, attrs) do
    badge_member
    |> cast(attrs, [:award_date])
    |> validate_required([:award_date])
  end
end
