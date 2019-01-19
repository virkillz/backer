defmodule Backer.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Account.User
  alias Comeonin.Bcrypt

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

  defp check_password(user, plain_text_password) do
    IO.inspect(plain_text_password)

    case Bcrypt.checkpw(plain_text_password, user.password_hash) do
      true -> {:ok, user}
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

  alias Backer.Account.Backer, as: Backerz

  @doc """
  Returns the list of backers.

  ## Examples

      iex> list_backers()
      [%Backer{}, ...]

  """
  def list_backers do
    Repo.all(Backerz)
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
   

  @doc """
  Creates a backer.

  ## Examples

      iex> create_backer(%{field: value})
      {:ok, %Backer{}}

      iex> create_backer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backer(attrs \\ %{}) do
    %Backerz{}
    |> Backerz.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backer.

  ## Examples

      iex> update_backer(backer, %{field: new_value})
      {:ok, %Backer{}}

      iex> update_backer(backer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backer(%Backerz{} = backer, attrs) do
    backer
    |> Backerz.create_changeset(attrs)
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

  alias Backer.Account.Pledger

  @doc """
  Returns the list of pledgers.

  ## Examples

      iex> list_pledgers()
      [%Pledger{}, ...]

  """
  def list_pledgers do
    Repo.all(Pledger)
    |> Repo.preload(:backer) 
     |> Repo.preload(:category) 
   |> Repo.preload(:title)
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
  def get_pledger!(id) do
   Repo.get!(Pledger, id) 
   |> Repo.preload(:backer) 
   |> Repo.preload(:category) 
   |> Repo.preload(:title)
   |> IO.inspect
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
    %Pledger{}
    |> Pledger.changeset(attrs)
    |> Repo.insert()
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

  @doc """
  Deletes a Pledger.

  ## Examples

      iex> delete_pledger(pledger)
      {:ok, %Pledger{}}

      iex> delete_pledger(pledger)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pledger(%Pledger{} = pledger) do
    Repo.delete(pledger)
  end


  def get_backers_pledger(id) do
    query = from p in Pledger,
    where: p.backer_id == ^id
    
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
