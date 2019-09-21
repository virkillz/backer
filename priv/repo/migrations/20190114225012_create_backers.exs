defmodule Backer.Repo.Migrations.CreateBackers do
  use Ecto.Migration

  def change do
    create table(:backers) do
      add(:username, :string)
      add(:passwordhash, :string)
      add(:display_name, :string)
      add(:backer_bio, :text)
      add(:full_name, :string)
      add(:email, :string)
      add(:gender, :string)
      add(:phone, :string)
      add(:birth_date, :date)
      add(:recover_phone, :string)
      add(:id_type, :string)
      add(:id_number, :string)
      add(:id_photo, :string)
      add(:id_photokyc, :string)
      add(:is_donee, :boolean, default: false, null: false)
      add(:avatar, :string)
      add(:email_verification_code, :string)
      add(:phone_verification_code, :string)
      add(:password_recovery_code, :string)
      add(:is_email_verified, :boolean, default: false, null: false)
      add(:is_phone_verified, :boolean, default: false, null: false)

      timestamps()
    end

    create(unique_index(:backers, [:username]))
    create(unique_index(:backers, [:phone]))
    create(unique_index(:backers, [:email]))
  end
end
