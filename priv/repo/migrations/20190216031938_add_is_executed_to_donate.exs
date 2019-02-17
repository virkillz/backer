defmodule Backer.Repo.Migrations.AddIsExecutedToDonate do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :is_executed, :boolean

    end

    create index(:donations, [:is_executed])
  end
end
