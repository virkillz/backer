defmodule Backer.Gamification do
  @moduledoc """
  The Gamification context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Gamification.Badge

  @doc """
  Returns the list of badges.

  ## Examples

      iex> list_badges()
      [%Badge{}, ...]

  """
  def list_badges do
    Repo.all(Badge)
  end

  @doc """
  Gets a single badge.

  Raises `Ecto.NoResultsError` if the Badge does not exist.

  ## Examples

      iex> get_badge!(123)
      %Badge{}

      iex> get_badge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_badge!(id), do: Repo.get!(Badge, id)

  @doc """
  Creates a badge.

  ## Examples

      iex> create_badge(%{field: value})
      {:ok, %Badge{}}

      iex> create_badge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_badge(attrs \\ %{}) do
    %Badge{}
    |> Badge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a badge.

  ## Examples

      iex> update_badge(badge, %{field: new_value})
      {:ok, %Badge{}}

      iex> update_badge(badge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_badge(%Badge{} = badge, attrs) do
    badge
    |> Badge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Badge.

  ## Examples

      iex> delete_badge(badge)
      {:ok, %Badge{}}

      iex> delete_badge(badge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_badge(%Badge{} = badge) do
    Repo.delete(badge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking badge changes.

  ## Examples

      iex> change_badge(badge)
      %Ecto.Changeset{source: %Badge{}}

  """
  def change_badge(%Badge{} = badge) do
    Badge.changeset(badge, %{})
  end

  alias Backer.Gamification.BadgeMember

  @doc """
  Returns the list of badge_members.

  ## Examples

      iex> list_badge_members()
      [%BadgeMember{}, ...]

  """
  def list_badge_members do
    Repo.all(BadgeMember)
  end

  def list_badge_members(%{"id" => id}) do
    query = from(m in BadgeMember, where: m.badge_id == ^id)
    Repo.all(query)
  end

  @doc """
  Gets a single badge_member.

  Raises `Ecto.NoResultsError` if the Badge member does not exist.

  ## Examples

      iex> get_badge_member!(123)
      %BadgeMember{}

      iex> get_badge_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_badge_member!(id), do: Repo.get!(BadgeMember, id)

  @doc """
  Creates a badge_member.

  ## Examples

      iex> create_badge_member(%{field: value})
      {:ok, %BadgeMember{}}

      iex> create_badge_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_badge_member(attrs \\ %{}) do
    %BadgeMember{}
    |> BadgeMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a badge_member.

  ## Examples

      iex> update_badge_member(badge_member, %{field: new_value})
      {:ok, %BadgeMember{}}

      iex> update_badge_member(badge_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_badge_member(%BadgeMember{} = badge_member, attrs) do
    badge_member
    |> BadgeMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BadgeMember.

  ## Examples

      iex> delete_badge_member(badge_member)
      {:ok, %BadgeMember{}}

      iex> delete_badge_member(badge_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_badge_member(%BadgeMember{} = badge_member) do
    Repo.delete(badge_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking badge_member changes.

  ## Examples

      iex> change_badge_member(badge_member)
      %Ecto.Changeset{source: %BadgeMember{}}

  """
  def change_badge_member(%BadgeMember{} = badge_member) do
    BadgeMember.changeset(badge_member, %{})
  end

  alias Backer.Gamification.Point

  @doc """
  Returns the list of points.

  ## Examples

      iex> list_points()
      [%Point{}, ...]

  """
  def list_points do
    Repo.all(Point)
  end

  @doc """
  Gets a single point.

  Raises `Ecto.NoResultsError` if the Point does not exist.

  ## Examples

      iex> get_point!(123)
      %Point{}

      iex> get_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_point!(id), do: Repo.get!(Point, id)

  @doc """
  Creates a point.

  ## Examples

      iex> create_point(%{field: value})
      {:ok, %Point{}}

      iex> create_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_point(attrs \\ %{}) do
    %Point{}
    |> Point.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a point.

  ## Examples

      iex> update_point(point, %{field: new_value})
      {:ok, %Point{}}

      iex> update_point(point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_point(%Point{} = point, attrs) do
    point
    |> Point.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_point(%Point{} = point) do
    Repo.delete(point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking point changes.

  ## Examples

      iex> change_point(point)
      %Ecto.Changeset{source: %Point{}}

  """
  def change_point(%Point{} = point) do
    Point.changeset(point, %{})
  end
end
