defmodule Backer.Repo.Migrations.AddTypeToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :type, :string
      add :publish_status, :string
    end

  end
end
