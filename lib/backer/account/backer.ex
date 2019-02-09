defmodule Backer.Account.Backer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stringhelper, as: Validate
  alias Generator.Username, as: Generator
  alias Backer.Constant

  schema "backers" do
    field(:avatar, :string)
    field(:backer_bio, :string)
    field(:birth_date, :date)
    field(:gender, :string)
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
    field(:password, :string, virtual: true)
    field(:passwordrepeat, :string, virtual: true)
    field(:code, :string, virtual: true)
    field(:phone, :string)
    field(:phone_verification_code, :string)
    field(:recover_phone, :string)
    field(:username, :string)

    has_many(:invoices, Backer.Finance.Invoice)
    has_many(:badges, Backer.Gamification.BadgeMember)
    has_one(:pledger, Backer.Account.Pledger)
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
      :gender,
      :email_verification_code,
      :phone_verification_code,
      :password_recovery_code,
      :is_email_verified,
      :is_phone_verified
    ])
    |> validate_required([:email, :display_name, :birth_date])
  end

  @doc false
  def change_password_changeset(backer, attrs) do
    backer
    |> cast(attrs, [
      :code,
      :password,
      :passwordrepeat
    ])
    |> validate_required([:password, :passwordrepeat, :code])
  end

  @doc false
  def update_password_changeset(backer, attrs) do
    backer
    |> cast(attrs, [
      :password,
      :passwordrepeat,
      :code
    ])
    |> validate_required([:password, :passwordrepeat, :code])
    |> validate_change_password
    |> reset_password_recovery_code
    |> validate_length(:password, min: 5)
    |> put_password_hash
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
    |> validate_required([:email, :display_name])
    |> validate_display_name
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> unique_constraint(:username)
    |> add_random_username
    |> add_random_avatar
    |> add_random_bio
  end

  @doc false
  def update_changeset(backer, attrs) do
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
    |> validate_required([:email, :display_name])
    |> validate_display_name
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> unique_constraint(:username)
  end

  @doc false
  def register_changeset(backer, attrs) do
    backer
    |> cast(attrs, [
      :username,
      :passwordhash,
      :display_name,
      :backer_bio,
      :full_name,
      :email,
      :phone,
      :password,
      :gender,
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
    |> validate_required([:email, :display_name, :password])
    |> validate_display_name
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3, max: 16)
    |> validate_length(:password, min: 5)
    |> add_random_username
    |> add_random_avatar
    |> add_random_bio
    |> add_email_verification_code
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        change(changeset, passwordhash: Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
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
    display_name = get_field(changeset, :display_name, "")

    return =
      case Validate.validate_alphanumeric_and_space(display_name) do
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
    username = get_field(changeset, :username)

    case username do
      nil -> changeset |> change(username: Generator.random())
      "" -> changeset |> change(username: Generator.random())
      other -> changeset
    end
  end

  defp add_random_avatar(changeset) do
    list = ["1", "2", "3", "4"]
    number = Enum.random(list)

    avatar = "/img/avatar" <> number <> ".jpg"
    changeset |> change(avatar: avatar)
  end

  defp add_random_bio(changeset) do
    list = Constant.profile_generator()
    bio = Enum.random(list)
    changeset |> change(backer_bio: bio)
  end

  defp add_email_verification_code(changeset) do
    changeset |> change(email_verification_code: Ecto.UUID.generate())
  end

  defp reset_password_recovery_code(changeset) do
    changeset |> change(password_recovery_code: "")
  end

  defp add_email_verification_code(changeset) do
    random_string = Ecto.UUID.generate()
    verification_code = :crypto.hash(:md5, random_string) |> Base.encode16(case: :lower)
    changeset |> change(email_verification_code: verification_code)
  end

  defp validate_full_name(changeset) do
    full_name = get_field(changeset, :full_name)

    return =
      case Validate.validate_alphanumeric_and_space(full_name) do
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

  defp validate_change_password(changeset) do
    password = get_field(changeset, :password)
    passwordrepeat = get_field(changeset, :passwordrepeat)

    if password != passwordrepeat do
      add_error(
        changeset,
        :passwordrepeat,
        "Password is not the same."
      )
    else
      changeset
    end
  end
end
