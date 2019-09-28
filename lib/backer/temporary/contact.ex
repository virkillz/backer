defmodule Backer.Temporary.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field(:email, :string)
    field(:is_read, :boolean, default: false)
    field(:message, :string)
    field(:name, :string)
    field(:phone, :string)
    field(:remark, :string)
    field(:status, :string, default: "unhandled")
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :phone, :email, :title, :message, :is_read, :remark, :status])
    |> validate_required([:name, :phone, :email, :title, :message])
  end
end
