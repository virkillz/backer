defmodule Backer.Masterdata do
  @moduledoc """
  The Masterdata context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Masterdata.Category
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Masterdata.Title
  alias Backer.Masterdata.Bank

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_category(id) do
    query_backer =
      from(b in Backerz,
        select: %{id: b.id, username: b.username, avatar: b.avatar, display_name: b.display_name}
      )

    query_title = from(t in Title, select: %{name: t.name})

    query =
      from(c in Category,
        where: c.id == ^id,
        preload: [donee: [backer: ^query_backer, title: ^query_title]]
      )

    Repo.one(query)
  end

  # def get_category(id) do

  #   # universities =
  #   #   from u in University,
  #   #     left_join: c in assoc(u, :city),
  #   #     limit: 2,
  #   #     select: %{title: u.title, city: %{title: c.title}}

  #   query = from c in Category,
  #   join: p in assoc(c, :donee),
  #   join: b in assoc(p, :backer),
  #   join: t in assoc(p, :title),
  #   where: c.id == ^id,
  #   # select: []
  #   # select: %{name: c.name, donee: %{background: p.background, title: %{name: t.name},backer: %{display_name: b.display_name, avatar: b.avatar}}}
  #   # select: [c.name]
  #   preload: [donee: {p, backer: b, title: t}]
  #   # select: %{id: c.id, donee: p}

  #   Repo.one(query)

  # end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  @doc """
  Returns the list of titles.

  ## Examples

      iex> list_titles()
      [%Title{}, ...]

  """
  def list_titles do
    Repo.all(Title)
  end

  @doc """
  Gets a single title.

  Raises `Ecto.NoResultsError` if the Title does not exist.

  ## Examples

      iex> get_title!(123)
      %Title{}

      iex> get_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_title!(id), do: Repo.get!(Title, id)

  @doc """
  Creates a title.

  ## Examples

      iex> create_title(%{field: value})
      {:ok, %Title{}}

      iex> create_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_title(attrs \\ %{}) do
    %Title{}
    |> Title.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a title.

  ## Examples

      iex> update_title(title, %{field: new_value})
      {:ok, %Title{}}

      iex> update_title(title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_title(%Title{} = title, attrs) do
    title
    |> Title.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Title.

  ## Examples

      iex> delete_title(title)
      {:ok, %Title{}}

      iex> delete_title(title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_title(%Title{} = title) do
    Repo.delete(title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking title changes.

  ## Examples

      iex> change_title(title)
      %Ecto.Changeset{source: %Title{}}

  """
  def change_title(%Title{} = title) do
    Title.changeset(title, %{})
  end

  alias Backer.Masterdata.Tier

  @doc """
  Returns the list of tiers.

  ## Examples

      iex> list_tiers()
      [%Tier{}, ...]

  """
  def list_tiers do
    Repo.all(Tier)
  end

  def list_tiers(%{"donee_id" => donee_id}) do
    query = from(t in Tier, where: t.donee_id == ^donee_id, order_by: t.amount)
    Repo.all(query)
  end

  def list_tiers_for_select(%{"donee_id" => donee_id}) do
    query = from(t in Tier, where: t.donee_id == ^donee_id, order_by: t.amount)

    result = Repo.all(query)

    if Enum.count(result) == 0 do
      generate_default_tier(donee_id)
    else
      result
    end
  end

  def generate_default_tier(donee_id) do
    tiers_attrs = Backer.Constant.default_tiers()

    Enum.map(tiers_attrs, fn x -> x |> Map.put("donee_id", donee_id) |> create_tier() end)
  end

  @doc """
  Gets a single tier.

  Raises `Ecto.NoResultsError` if the Tier does not exist.

  ## Examples

      iex> get_tier!(123)
      %Tier{}

      iex> get_tier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tier!(id), do: Repo.get!(Tier, id)

  @doc """
  Creates a tier.

  ## Examples

      iex> create_tier(%{field: value})
      {:ok, %Tier{}}

      iex> create_tier(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tier(attrs \\ %{}) do
    %Tier{}
    |> Tier.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tier.

  ## Examples

      iex> update_tier(tier, %{field: new_value})
      {:ok, %Tier{}}

      iex> update_tier(tier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tier(%Tier{} = tier, attrs) do
    tier
    |> Tier.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tier.

  ## Examples

      iex> delete_tier(tier)
      {:ok, %Tier{}}

      iex> delete_tier(tier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tier(%Tier{} = tier) do
    Repo.delete(tier)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tier changes.

  ## Examples

      iex> change_tier(tier)
      %Ecto.Changeset{source: %Tier{}}

  """
  def change_tier(%Tier{} = tier) do
    Tier.changeset(tier, %{})
  end

  @doc """
  Returns the list of banks.

  ## Examples

      iex> list_banks()
      [%Bank{}, ...]

  """
  def list_banks do
    Repo.all(Bank)
  end

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank!(id), do: Repo.get!(Bank, id)

  @doc """
  Creates a bank.

  ## Examples

      iex> create_bank(%{field: value})
      {:ok, %Bank{}}

      iex> create_bank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank(attrs \\ %{}) do
    %Bank{}
    |> Bank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank.

  ## Examples

      iex> update_bank(bank, %{field: new_value})
      {:ok, %Bank{}}

      iex> update_bank(bank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank(%Bank{} = bank, attrs) do
    bank
    |> Bank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bank.

  ## Examples

      iex> delete_bank(bank)
      {:ok, %Bank{}}

      iex> delete_bank(bank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank(%Bank{} = bank) do
    Repo.delete(bank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank changes.

  ## Examples

      iex> change_bank(bank)
      %Ecto.Changeset{source: %Bank{}}

  """
  def change_bank(%Bank{} = bank) do
    Bank.changeset(bank, %{})
  end
end
