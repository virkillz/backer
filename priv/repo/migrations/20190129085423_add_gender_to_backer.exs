defmodule Backer.Repo.Migrations.AddGenderToBacker do
  use Ecto.Migration

  def change do
    alter table(:backers) do
      add :gender, :string
    end
  end
end
