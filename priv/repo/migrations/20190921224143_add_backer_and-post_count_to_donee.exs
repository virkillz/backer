defmodule :"Elixir.Backer.Repo.Migrations.AddBackerAnd-postCountToDonee" do
  use Ecto.Migration

  def change do
    alter table(:donees) do
      add(:backer_count, :integer)
      add(:post_count, :integer)
    end

    create(index(:donees, [:backer_count]))
    create(index(:donees, [:post_count]))
  end
end
