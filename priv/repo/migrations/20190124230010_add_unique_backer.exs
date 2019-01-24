defmodule Backer.Repo.Migrations.AddUniqueBacker do
  use Ecto.Migration

  def change do
	create unique_index(:backers, [:email, :phone, :username])
  end
end
