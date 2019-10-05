defmodule Backer.Aggregate do
  @moduledoc """
  The Aggregate context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Aggregate.BackingAggregate

  @doc """
  Returns the list of backingaggregates.

  ## Examples

      iex> list_backingaggregates()
      [%BackingAggregate{}, ...]

  """
  def list_backingaggregates do
    Repo.all(BackingAggregate)
  end

  @doc """
  Gets a single backing_aggregate.

  Raises `Ecto.NoResultsError` if the Backing aggregate does not exist.

  ## Examples

      iex> get_backing_aggregate!(123)
      %BackingAggregate{}

      iex> get_backing_aggregate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backing_aggregate!(id), do: Repo.get!(BackingAggregate, id)

  @doc """
  Creates a backing_aggregate.

  ## Examples

      iex> create_backing_aggregate(%{field: value})
      {:ok, %BackingAggregate{}}

      iex> create_backing_aggregate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_backing_aggregate(attrs \\ %{}) do
    %BackingAggregate{}
    |> BackingAggregate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a backing_aggregate.

  ## Examples

      iex> update_backing_aggregate(backing_aggregate, %{field: new_value})
      {:ok, %BackingAggregate{}}

      iex> update_backing_aggregate(backing_aggregate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_backing_aggregate(%BackingAggregate{} = backing_aggregate, attrs) do
    backing_aggregate
    |> BackingAggregate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BackingAggregate.

  ## Examples

      iex> delete_backing_aggregate(backing_aggregate)
      {:ok, %BackingAggregate{}}

      iex> delete_backing_aggregate(backing_aggregate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_backing_aggregate(%BackingAggregate{} = backing_aggregate) do
    Repo.delete(backing_aggregate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking backing_aggregate changes.

  ## Examples

      iex> change_backing_aggregate(backing_aggregate)
      %Ecto.Changeset{source: %BackingAggregate{}}

  """
  def change_backing_aggregate(%BackingAggregate{} = backing_aggregate) do
    BackingAggregate.changeset(backing_aggregate, %{})
  end
end
