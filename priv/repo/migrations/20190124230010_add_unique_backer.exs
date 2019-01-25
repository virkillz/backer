defmodule Backer.Repo.Migrations.AddUniqueBacker do
  use Ecto.Migration

  def change do
	create unique_index(:backers, [:username])
	create unique_index(:backers, [:phone])
	create unique_index(:backers, [:email])
  end
end
