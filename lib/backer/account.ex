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
  alias Backer.Account.Donee
  alias Backer.Settings
  alias Backer.Account.Metadata
  alias Backer.Account.PaymentAccount

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user do
    Repo.all(User)
  end

  def count_backer do
    Repo.one(from(b in Backerz, select: count(b.id)))
  end

  def count_donee do
    Repo.one(from(d in Donee, select: count(d.id)))
  end

  def count_backer_new_today do
    0
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
    query =
      from(b in Backerz,
        order_by: [desc: b.id]
      )

    Repo.all(query)
  end

  def list_backers(params) do
    query =
      from(b in Backerz,
        order_by: [desc: b.id]
      )

    query |> Repo.paginate(params)
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

  def get_random_backer(limit) do
    query =
      from(b in Backerz, preload: [badges: :badge], limit: ^limit, order_by: fragment("RANDOM()"))

    Repo.all(query)
  end

  def get_random_donee(limit) do
    query =
      from(d in Donee,
        where: d.status == "published",
        limit: ^limit,
        order_by: fragment("RANDOM()"),
        preload: [:backer, :title, :tier]
      )

    Repo.all(query)
  end

  def get_random_doneex(limit) do
    query =
      from(p in Backerz,
        where: p.is_donee == true,
        limit: ^limit,
        order_by: fragment("RANDOM()"),
        preload: [donee: [:title, :tier]]
      )

    Repo.all(query)
  end

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

  def sign_up_backer(attrs \\ %{}) do
    attrs

    %Backerz{}
    |> Backerz.sign_up_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_backer_front(email, plain_text_password) do
    query = from(b in Backerz, where: b.email == ^email)

    Repo.one(query)
    |> check_password(plain_text_password)
  end

  @doc """
  Returns the list of payment_accounts.

  ## Examples

      iex> list_payment_accounts()
      [%PaymentAccount{}, ...]

  """
  def list_payment_accounts do
    Repo.all(PaymentAccount)
  end

  @doc """
  Gets a single payment_account.

  Raises `Ecto.NoResultsError` if the Payment account does not exist.

  ## Examples

      iex> get_payment_account!(123)
      %PaymentAccount{}

      iex> get_payment_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_account!(id), do: Repo.get!(PaymentAccount, id)

  @doc """
  Creates a payment_account.

  ## Examples

      iex> create_payment_account(%{field: value})
      {:ok, %PaymentAccount{}}

      iex> create_payment_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_account(attrs \\ %{}) do
    %PaymentAccount{}
    |> PaymentAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_account.

  ## Examples

      iex> update_payment_account(payment_account, %{field: new_value})
      {:ok, %PaymentAccount{}}

      iex> update_payment_account(payment_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_account(%PaymentAccount{} = payment_account, attrs) do
    payment_account
    |> PaymentAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentAccount.

  ## Examples

      iex> delete_payment_account(payment_account)
      {:ok, %PaymentAccount{}}

      iex> delete_payment_account(payment_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_account(%PaymentAccount{} = payment_account) do
    Repo.delete(payment_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_account changes.

  ## Examples

      iex> change_payment_account(payment_account)
      %Ecto.Changeset{source: %PaymentAccount{}}

  """
  def change_payment_account(%PaymentAccount{} = payment_account) do
    PaymentAccount.changeset(payment_account, %{})
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
    |> Backerz.update_changeset(attrs)
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
  Returns the list of donees.

  ## Examples

      iex> list_donees()
      [%Donee{}, ...]

  """
  def list_donees do
    query = from(d in Donee, order_by: [desc: d.id], preload: [:backer, :category, :title])

    Repo.all(query)
  end

  def list_donees_minimum do
    list_donees
    |> Enum.map(fn x ->
      %{
        donee_id: x.id,
        username: x.backer.username,
        display_name: x.backer.display_name,
        email: x.backer.email
      }
    end)
  end

  def list_donees(params) do
    query = from(p in Donee, preload: [:backer, :category, :title])

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single donee.

  Raises `Ecto.NoResultsError` if the Donee does not exist.

  ## Examples

      iex> get_donee!(123)
      %Donee{}

      iex> get_donee!(456)
      ** (Ecto.NoResultsError)

  """

  def get_donee(%{"backer_id" => backer_id}) do
    query =
      from(p in Donee,
        preload: [:backer, :category, :title, :tier],
        where: p.backer_id == ^backer_id
      )

    Repo.one(query)
  end

  def get_highlight_donee_homepage() do
    main_featured_donee_id = Settings.get_setting(:key, "main_featured_donee")

    if is_nil(main_featured_donee_id) do
      nil
    else
      donee_id =
        case Integer.parse(main_featured_donee_id.value) do
          :error -> nil
          {number, _} -> number
        end

      get_donee(:id, donee_id)
    end
  end

  def get_donee_compact(%{"backer_id" => backer_id}) do
    query =
      from(p in Donee,
        preload: [:backer, :category, :title, :tier],
        where: p.backer_id == ^backer_id
      )

    donee = Repo.one(query) |> IO.inspect()

    if donee != nil do
      %{
        backer_id: donee.backer.id,
        donee_id: donee.id,
        username: donee.backer.username,
        display_name: donee.backer.display_name,
        avatar: donee.backer.avatar,
        title: donee.title.name,
        background: donee.background,
        tiers: donee.tier,
        email: donee.backer.email,
        backer_bio: donee.backer.backer_bio,
        tagline: donee.tagline,
        backer_count: donee.backer_count,
        post_count: donee.post_count
      }
    else
      nil
    end
  end

  def get_donee!(id) do
    query = from(p in Donee, preload: [:backer, :category, :title, :tier], where: p.id == ^id)

    Repo.one!(query)
  end

  def get_donee(:id, id) do
    query = from(p in Donee, preload: [:backer, :category, :title, :tier], where: p.id == ^id)

    Repo.one(query)
  end

  def get_donee(%{"username" => username}) do
    query =
      from(p in Backerz,
        where: p.username == ^username and p.is_donee == true,
        preload: [donee: [:backer, :title, :tier]]
      )

    result = Repo.one(query)

    if is_nil(result) do
      nil
    else
      result.donee
    end
  end

  def get_donee(%{"category_id" => id}) do
    query =
      from(b in Backerz,
        join: p in assoc(b, :donee),
        join: t in assoc(p, :title),
        where: p.category_id == ^id and b.is_donee == true,
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
  Creates a donee.

  ## Examples

      iex> create_donee(%{field: value})
      {:ok, %Donee{}}

      iex> create_donee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_donee(attrs \\ %{}) do
    donee_changeset = %Donee{} |> Donee.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:donee, donee_changeset)
    |> Ecto.Multi.run(:backer, fn _repo, %{donee: donee} ->
      get_backer!(donee.backer_id)
      |> Backerz.update_changeset(%{"is_donee" => true})
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:tier, fn _repo, %{donee: donee} ->
      # get default tier from constant
      tiers = Masterdata.generate_default_tier(donee.id)

      if Enum.count(tiers) == 3 do
        {:ok, tiers}
      else
        {:error, "Cannot create tiers"}
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a donee.

  ## Examples

      iex> update_donee(donee, %{field: new_value})
      {:ok, %Donee{}}

      iex> update_donee(donee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_donee(%Donee{} = donee, attrs) do
    donee
    |> Donee.changeset(attrs)
    |> Repo.update()
  end

  def random_donee(limit) do
    query =
      from(b in Backerz,
        where: b.is_donee == true,
        order_by: fragment("RANDOM()"),
        preload: :donee,
        limit: 10
      )

    Repo.all(query)
  end

  @doc """
  Deletes a Donee.

  ## Examples

      iex> delete_donee(donee)
      {:ok, %Donee{}}

      iex> delete_donee(donee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_donee(%Donee{} = donee) do
    backer_changeset =
      get_backer!(donee.backer_id) |> Backerz.update_changeset(%{"is_donee" => false})

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:donee, donee)
    |> Ecto.Multi.update(:backer, backer_changeset)
    |> Repo.transaction()
  end

  def get_backers_donee(id) do
    query =
      from(p in Donee,
        where: p.backer_id == ^id
      )

    case Repo.all(query) do
      [] -> nil
      [a] -> a
      [h | _] -> h
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking donee changes.

  ## Examples

      iex> change_donee(donee)
      %Ecto.Changeset{source: %Donee{}}

  """
  def change_donee(%Donee{} = donee) do
    Donee.changeset(donee, %{})
  end

  def get_user_links_of(backer_id) do
    query =
      from(m in Metadata,
        where: m.backer_id == ^backer_id,
        where: m.group == "user_link"
      )

    query
    |> Repo.all()
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.key, x.value_string) end)
  end

  def search_backer(q) do
    query_backer =
      from(b in Backerz,
        where: like(b.display_name, ^q),
        or_where: like(b.username, ^q),
        or_where: like(b.email, ^q),
        or_where: like(b.display_name, ^q),
        or_where: like(b.backer_bio, ^q),
        preload: [:donee]
      )

    Repo.all(query_backer)
  end

  def search_donee(q) do
    query_donee =
      from(b in Donee,
        where: like(b.donee_overview, ^q),
        or_where: like(b.tagline, ^q),
        preload: [:backer]
      )

    backer_list =
      q
      |> search_backer()
      |> Enum.filter(fn x -> x.is_donee end)
      |> Enum.map(fn x ->
        %{
          display_name: x.display_name,
          avatar: x.avatar,
          username: x.username,
          tagline: x.donee.tagline,
          background: x.donee.background,
          backer_count: x.donee.backer_count
        }
      end)

    donee_list =
      query_donee
      |> Repo.all()
      |> Enum.map(fn x ->
        %{
          display_name: x.backer.display_name,
          avatar: x.backer.avatar,
          username: x.backer.username,
          tagline: x.tagline,
          background: x.background,
          backer_count: x.backer_count
        }
      end)

    donee_list ++ backer_list
  end

  def user_link_upsert(%{"backer_id" => backer_id, "key" => key, "group" => group} = attrs) do
    query =
      from(m in Metadata,
        where: m.backer_id == ^backer_id,
        where: m.key == ^key,
        where: m.group == ^group
      )

    metadata = Repo.one(query)

    if is_nil(metadata) do
      # create metadata
      create_metadata(attrs)
      # :ok
    else
      # no need update if value is the same
      if metadata.value_string == attrs["value_string"] do
        {:ok, metadata}
      else
        update_metadata(metadata, %{"value_string" => attrs["value_string"]})
      end
    end
  end

  def batch_user_link_upsert(attrs, backer_id) do
    keys =
      attrs
      |> Map.keys()
      |> Enum.map(fn x ->
        %{
          "backer_id" => backer_id,
          "key" => x,
          "value_string" => attrs[x],
          "group" => "user_link"
        }
      end)
      |> Enum.map(fn x -> user_link_upsert(x) end)
  end

  @doc """
  Returns the list of metadatas.

  ## Examples

      iex> list_metadatas()
      [%Metadata{}, ...]

  """
  def list_metadatas(params) do
    Repo.paginate(Metadata, params)
  end

  @doc """
  Gets a single metadata.

  Raises `Ecto.NoResultsError` if the Metadata does not exist.

  ## Examples

      iex> get_metadata!(123)
      %Metadata{}

      iex> get_metadata!(456)
      ** (Ecto.NoResultsError)

  """
  def get_metadata!(id), do: Repo.get!(Metadata, id)

  @doc """
  Creates a metadata.

  ## Examples

      iex> create_metadata(%{field: value})
      {:ok, %Metadata{}}

      iex> create_metadata(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_metadata(attrs \\ %{}) do
    %Metadata{}
    |> Metadata.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a metadata.

  ## Examples

      iex> update_metadata(metadata, %{field: new_value})
      {:ok, %Metadata{}}

      iex> update_metadata(metadata, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_metadata(%Metadata{} = metadata, attrs) do
    metadata
    |> Metadata.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Metadata.

  ## Examples

      iex> delete_metadata(metadata)
      {:ok, %Metadata{}}

      iex> delete_metadata(metadata)
      {:error, %Ecto.Changeset{}}

  """
  def delete_metadata(%Metadata{} = metadata) do
    Repo.delete(metadata)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking metadata changes.

  ## Examples

      iex> change_metadata(metadata)
      %Ecto.Changeset{source: %Metadata{}}

  """
  def change_metadata(%Metadata{} = metadata) do
    Metadata.changeset(metadata, %{})
  end
end
