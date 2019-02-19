defmodule Backer.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Account.User
  alias Comeonin.Bcrypt
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Masterdata.Tier
  alias Backer.Account.Pledger

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_frontend(attrs \\ %{}) do
    %User{}
    |> User.front_registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(username, plain_text_password) do
    query = from(u in User, where: u.username == ^username)

    Repo.one(query)
    |> check_password(plain_text_password)
  end

  def authenticate_user_front(email, plain_text_password) do
    query = from(u in User, where: u.email == ^email)

    Repo.one(query)
    |> check_password(plain_text_password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect credential"}

  defp check_password(%User{} = user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect credential"}
    end
  end

  defp check_password(%Backerz{} = backer, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, backer.passwordhash) do
      true -> {:ok, backer}
      false -> {:error, "Incorrect credential"}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def backer_verification_valid(code) do
    query = from(b in Backerz, where: b.email_verification_code == ^code)

    case Repo.one(query) do
      nil ->
        {:error, "not found"}

      result ->
        case result.is_email_verified do
          true -> {:already, "already"}
          false -> {:not_yet, result}
        end
    end
  end

  @doc """
  Returns the list of backers.

  ## Examples

      iex> list_backers()
      [%Backer{}, ...]

  """
  def list_backers do
    Repo.all(Backerz)
  end

  def list_backers(params) do
    Backerz |> Repo.paginate(params)
  end

  @doc """
  Gets a single backer.

  Raises `Ecto.NoResultsError` if the Backer does not exist.

  ## Examples

      iex> get_backer!(123)
      %Backer{}

      iex> get_backer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backer!(id), do: Repo.get!(Backerz, id)

  def get_backer(%{"username" => username}) do
    query = from(b in Backerz, where: b.username == ^username, preload: [badges: :badge])
    Repo.one(query)
  end

  def get_backer(%{"email" => email}) do
    Repo.get_by(Backerz, email: email)
  end

  def get_backer(%{"password_recovery_code" => code}) do
    Repo.get_by(Backerz, password_recovery_code: code)
  end

  def get_backer(id), do: Repo.get(Backerz, id)

  @doc """
  Creates a backer.

  ## Examples

      iex> create_backer(%{field: value})
      {:ok, %Backer{}}

      iex> create_backer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backer(attrs \\ %{}) do
    attrs

    %Backerz{}
    |> Backerz.create_changeset(attrs)
    |> Repo.insert()
  end

  def register_backer(attrs \\ %{}) do
    attrs

    %Backerz{}
    |> Backerz.register_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_backer_front(email, plain_text_password) do
    query = from(b in Backerz, where: b.email == ^email)

    Repo.one(query)
    |> check_password(plain_text_password)
  end

  def get_current_user(%Plug.Conn{private: %{:plug_session => %{"current_user_id" => id}}}) do
    current_user = get_backer(id)

    if current_user != nil do
      current_user
    else
      nil
    end
  end

  def get_current_user(conn) do
    nil
  end

  @doc """
  Updates a backer.

  ## Examples

      iex> update_backer(backer, %{field: new_value})
      {:ok, %Backer{}}

      iex> update_backer(backer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def validate_backer(backer) do
    update_backer(backer, %{"is_email_verified" => true})
  end

  def update_backer(%Backerz{} = backer, attrs) do
    backer
    |> Backerz.create_changeset(attrs)
    |> Repo.update()
  end

  def update_password_backer(%Backerz{} = backer, attrs) do
    backer
    |> Backerz.update_password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Backer.

  ## Examples

      iex> delete_backer(backer)
      {:ok, %Backer{}}

      iex> delete_backer(backer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backer(%Backerz{} = backer) do
    Repo.delete(backer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backer changes.

  ## Examples

      iex> change_backer(backer)
      %Ecto.Changeset{source: %Backer{}}

  """
  def change_backer(%Backerz{} = backer) do
    Backerz.new_changeset(backer, %{})
  end

  def change_password_backer(%Backerz{} = backer) do
    Backerz.change_password_changeset(backer, %{})
  end

  @doc """
  Returns the list of pledgers.

  ## Examples

      iex> list_pledgers()
      [%Pledger{}, ...]

  """
  def list_pledgers do
    query = from(p in Pledger, preload: [:backer, :category, :title])

    Repo.all(query)
  end

  def list_pledgers(params) do
    query = from(p in Pledger, preload: [:backer, :category, :title])

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single pledger.

  Raises `Ecto.NoResultsError` if the Pledger does not exist.

  ## Examples

      iex> get_pledger!(123)
      %Pledger{}

      iex> get_pledger!(456)
      ** (Ecto.NoResultsError)

  """

  def get_pledger(%{"backer_id" => backer_id}) do
    query =
      from(p in Pledger,
        preload: [:backer, :category, :title, :tier],
        where: p.backer_id == ^backer_id
      )

    Repo.one(query)
  end

  def get_pledger_compact(%{"backer_id" => backer_id}) do
    query =
      from(p in Pledger,
        preload: [:backer, :category, :title, :tier],
        where: p.backer_id == ^backer_id
      )

    pledger = Repo.one(query)

    if pledger != nil do
      %{
        backer_id: pledger.backer.id,
        pledger_id: pledger.id,
        avatar: pledger.backer.avatar,
        title: pledger.title.name,
        background: pledger.background,
        tiers: pledger.tier
      }
    else
      nil
    end
  end

  def get_pledger!(id) do
    query = from(p in Pledger, preload: [:backer, :category, :title, :tier], where: p.id == ^id)

    Repo.one!(query)
  end

  def get_pledger(%{"username" => username}) do
    query =
      from(p in Backerz,
        where: p.username == ^username and p.is_pledger == true,
        preload: [pledger: [:title, :tier]]
      )

    Repo.one(query)
  end

  def get_pledger(%{"category_id" => id}) do
    query =
      from(b in Backerz,
        join: p in assoc(b, :pledger),
        join: t in assoc(p, :title),
        where: p.category_id == ^id and b.is_pledger == true,
        select: %{
          background: p.background,
          display_name: b.display_name,
          title: t.name,
          avatar: b.avatar,
          username: b.username
        }
      )

    Repo.all(query)
  end

  @doc """
  Creates a pledger.

  ## Examples

      iex> create_pledger(%{field: value})
      {:ok, %Pledger{}}

      iex> create_pledger(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pledger(attrs \\ %{}) do
    pledger_changeset = %Pledger{} |> Pledger.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:pledger, pledger_changeset)
    |> Ecto.Multi.run(:backer, fn _repo, %{pledger: pledger} ->
      get_backer!(pledger.backer_id)
      |> Backerz.update_changeset(%{"is_pledger" => true})
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:tier, fn _repo, %{pledger: pledger} ->
      # get default tier from constant
      tier_attr = Map.put(Backer.Constant.default_tier(), "pledger_id", pledger.id)

      %Tier{}
      |> Tier.changeset(tier_attr)
      |> Repo.insert()
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a pledger.

  ## Examples

      iex> update_pledger(pledger, %{field: new_value})
      {:ok, %Pledger{}}

      iex> update_pledger(pledger, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pledger(%Pledger{} = pledger, attrs) do
    pledger
    |> Pledger.changeset(attrs)
    |> Repo.update()
  end

  def random_pledger(limit) do
    query =
      from(b in Backerz,
        where: b.is_pledger == true,
        order_by: fragment("RANDOM()"),
        preload: :pledger,
        limit: 10
      )

    Repo.all(query)
  end

  @doc """
  Deletes a Pledger.

  ## Examples

      iex> delete_pledger(pledger)
      {:ok, %Pledger{}}

      iex> delete_pledger(pledger)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pledger(%Pledger{} = pledger) do
    backer_changeset =
      get_backer!(pledger.backer_id) |> Backerz.update_changeset(%{"is_pledger" => false})

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:pledger, pledger)
    |> Ecto.Multi.update(:backer, backer_changeset)
    |> Repo.transaction()
  end

  def get_backers_pledger(id) do
    query =
      from(p in Pledger,
        where: p.backer_id == ^id
      )

    case Repo.all(query) do
      [] -> nil
      [a] -> a
      [h | _] -> h
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pledger changes.

  ## Examples

      iex> change_pledger(pledger)
      %Ecto.Changeset{source: %Pledger{}}

  """
  def change_pledger(%Pledger{} = pledger) do
    Pledger.changeset(pledger, %{})
  end
end
