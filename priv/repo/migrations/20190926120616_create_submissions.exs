defmodule Backer.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :donee_name, :string
      add :donee_website, :string
      add :donee_description, :text
      add :applicant_name, :string
      add :applicant_email, :string
      add :applicant_phone, :string
      add :phone_preffered, :boolean, default: false, null: false
      add :email_preffered, :boolean, default: false, null: false
      add :whatsapp_preffered, :boolean, default: false, null: false
      add :handle_status, :string
      add :comment, :text
      add :acceptance_status, :string

      timestamps()
    end

  end
end
