defmodule Backer.Aggregate do
  @moduledoc """
  The Aggregate context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Aggregate.BackingAggregate
  alias Backer.Finance

  def build_aggregate(backer_id, donee_id) do
    case get_backingaggregate(backer_id, donee_id) do
      nil ->
        list_donation =
          Finance.list_donations(%{"backer_id" => backer_id, "donee_id" => donee_id})

        IO.inspect(list_donation)

        if Enum.count(list_donation) == 0 do
          {:error, "No donation founded fom backer_id #{backer_id} to donee_id #{donee_id}"}
        else
          first = List.first(list_donation)
          {:ok, backer_since} = NaiveDateTime.new(first.year, first.month, 1, 0, 0, 0)
          last = List.last(list_donation)
          total = Enum.reduce(list_donation, 0, fn x, acc -> x.amount + acc end)
          {:ok, now} = DateTime.now("Etc/UTC")

          [current] =
            Enum.filter(list_donation, fn x -> x.month == now.month && x.year == now.year end)

          %{
            "accumulative_donation" => total,
            "backer_id" => backer_id,
            "donee_id" => donee_id,
            "backing_status" => "active",
            "last_amount" => last.amount,
            "last_tier" => last.backer_tier.title,
            "score" => total,
            "backer_since" => backer_since
          }
        end

      item ->
        :update
    end
  end

  def get_backingaggregate(backer_id, donee_id) do
    query =
      from(b in BackingAggregate,
        where: b.backer_id == ^backer_id,
        where: b.donee_id == ^donee_id
      )

    Repo.one(query)
  end

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
