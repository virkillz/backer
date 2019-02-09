defmodule Backer.Gamification.BadgeMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "badge_members" do
    field(:award_date, :date)
    field(:backer_id, :id)

    belongs_to(:badge, Backer.Gamification.Badge)

    timestamps()
  end

  @doc false
  def changeset(badge_member, attrs) do
    badge_member
    |> cast(attrs, [:award_date, :backer_id, :badge_id])
    |> validate_required([:award_date, :backer_id, :badge_id])
  end
end
