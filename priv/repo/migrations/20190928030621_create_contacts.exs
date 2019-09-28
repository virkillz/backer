defmodule Backer.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :phone, :string
      add :email, :string
      add :title, :string
      add :message, :text
      add :is_read, :boolean, default: false, null: false
      add :remark, :text
      add :status, :string

      timestamps()
    end

  end
end
