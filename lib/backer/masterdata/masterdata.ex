defmodule Backer.Masterdata do
  @moduledoc """
  The Masterdata context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Masterdata.Category

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

  alias Backer.Masterdata.Title

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
end
