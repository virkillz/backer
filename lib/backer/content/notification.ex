defmodule Backer.Content.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field(:additional_note, :string)
    field(:content, :string)
    field(:is_read, :boolean, default: false)
    field(:other_ref_id, :integer)
    field(:type, :string)
    field(:user_id, :id)
    field(:backer_id, :id)
    field(:donee_id, :id)

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [
      :type,
      :user_id,
      :backer_id,
      :donee_id,
      :content,
      :is_read,
      :other_ref_id,
      :additional_note
    ])
    |> validate_required([:type, :content, :is_read, :other_ref_id, :additional_note])
  end
end
