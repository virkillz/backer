defmodule Backer.Account.Backer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stringhelper, as: Validate
  alias Generator.Username, as: Generator

  schema "backers" do
    field(:avatar, :string)
    field(:backer_bio, :string)
    field(:birth_date, :date)
    field(:display_name, :string)
    field(:email, :string)
    field(:email_verification_code, :string)
    field(:full_name, :string)
    field(:id_number, :string)
    field(:id_photo, :string)
    field(:id_photokyc, :string)
    field(:id_type, :string)
    field(:is_email_verified, :boolean, default: false)
    field(:is_phone_verified, :boolean, default: false)
    field(:is_pledger, :boolean, default: false)
    field(:password_recovery_code, :string)
    field(:passwordhash, :string)
    field(:phone, :string)
    field(:phone_verification_code, :string)
    field(:recover_phone, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def new_changeset(backer, attrs) do
    backer
    |> cast(attrs, [
      :username,
      :passwordhash,
      :display_name,
      :backer_bio,
      :full_name,
      :email,
      :phone,
      :birth_date,
      :recover_phone,
      :id_type,
      :id_number,
      :id_photo,
      :id_photokyc,
      :is_pledger,
      :avatar,
      :email_verification_code,
      :phone_verification_code,
      :password_recovery_code,
      :is_email_verified,
      :is_phone_verified
    ])
    |> validate_required([:email, :username, :phone, :birth_date])
  end

  @doc false
  def create_changeset(backer, attrs) do
    backer
    |> cast(attrs, [
      :username,
      :passwordhash,
      :display_name,
      :backer_bio,
      :full_name,
      :email,
      :phone,
      :birth_date,
      :recover_phone,
      :id_type,
      :id_number,
      :id_photo,
      :id_photokyc,
      :is_pledger,
      :avatar,
      :email_verification_code,
      :phone_verification_code,
      :password_recovery_code,
      :is_email_verified,
      :is_phone_verified
    ])
    |> validate_required([:email, :phone, :birth_date])
    |> add_random_username
    |> validate_username
    |> validate_display_name
    |> validate_full_name
  end

  defp validate_username(changeset) do
    uname = get_field(changeset, :username)

    return =
      case uname do
        "" ->
          changeset

        _ ->
          case Validate.validate_alphanumeric(uname) do
            {:ok, _} ->
              changeset

            {:error, _reason} ->
              add_error(
                changeset,
                :username,
                "Username only can consisted of alphanumeric character"
              )
          end
      end
  end

  defp validate_display_name(changeset) do
    display_name = get_field(changeset, :display_name)

    return =
      case Validate.validate_alphanumeric(display_name) do
        {:ok, _} ->
          changeset

        {:error, _reason} ->
          add_error(
            changeset,
            :display_name,
            "Display name only can consisted of alphanumeric character"
          )
      end
  end

  defp add_random_username(changeset) do
    changeset |> change(username: Generator.random())
  end

  defp validate_full_name(changeset) do
    full_name = get_field(changeset, :full_name)

    return =
      case Validate.validate_alphanumeric(full_name) do
        {:ok, _} ->
          changeset

        {:error, _reason} ->
          add_error(
            changeset,
            :full_name,
            "Full Name only can consisted of alphanumeric character"
          )
      end
  end
end