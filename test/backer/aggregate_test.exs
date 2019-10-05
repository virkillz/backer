defmodule Backer.AggregateTest do
  use Backer.DataCase

  alias Backer.Aggregate

  describe "backingaggregates" do
    alias Backer.Aggregate.BackingAggregate

    @valid_attrs %{accumulative_donation: 42, backer_since: ~N[2010-04-17 14:00:00], backing_status: "some backing_status", last_amount: 42, last_tier: "some last_tier", score: 42}
    @update_attrs %{accumulative_donation: 43, backer_since: ~N[2011-05-18 15:01:01], backing_status: "some updated backing_status", last_amount: 43, last_tier: "some updated last_tier", score: 43}
    @invalid_attrs %{accumulative_donation: nil, backer_since: nil, backing_status: nil, last_amount: nil, last_tier: nil, score: nil}

    def backing_aggregate_fixture(attrs \\ %{}) do
      {:ok, backing_aggregate} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Aggregate.create_backing_aggregate()

      backing_aggregate
    end

    test "list_backingaggregates/0 returns all backingaggregates" do
      backing_aggregate = backing_aggregate_fixture()
      assert Aggregate.list_backingaggregates() == [backing_aggregate]
    end

    test "get_backing_aggregate!/1 returns the backing_aggregate with given id" do
      backing_aggregate = backing_aggregate_fixture()
      assert Aggregate.get_backing_aggregate!(backing_aggregate.id) == backing_aggregate
    end

    test "create_backing_aggregate/1 with valid data creates a backing_aggregate" do
      assert {:ok, %BackingAggregate{} = backing_aggregate} = Aggregate.create_backing_aggregate(@valid_attrs)
      assert backing_aggregate.accumulative_donation == 42
      assert backing_aggregate.backer_since == ~N[2010-04-17 14:00:00]
      assert backing_aggregate.backing_status == "some backing_status"
      assert backing_aggregate.last_amount == 42
      assert backing_aggregate.last_tier == "some last_tier"
      assert backing_aggregate.score == 42
    end

    test "create_backing_aggregate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Aggregate.create_backing_aggregate(@invalid_attrs)
    end

    test "update_backing_aggregate/2 with valid data updates the backing_aggregate" do
      backing_aggregate = backing_aggregate_fixture()
      assert {:ok, %BackingAggregate{} = backing_aggregate} = Aggregate.update_backing_aggregate(backing_aggregate, @update_attrs)
      assert backing_aggregate.accumulative_donation == 43
      assert backing_aggregate.backer_since == ~N[2011-05-18 15:01:01]
      assert backing_aggregate.backing_status == "some updated backing_status"
      assert backing_aggregate.last_amount == 43
      assert backing_aggregate.last_tier == "some updated last_tier"
      assert backing_aggregate.score == 43
    end

    test "update_backing_aggregate/2 with invalid data returns error changeset" do
      backing_aggregate = backing_aggregate_fixture()
      assert {:error, %Ecto.Changeset{}} = Aggregate.update_backing_aggregate(backing_aggregate, @invalid_attrs)
      assert backing_aggregate == Aggregate.get_backing_aggregate!(backing_aggregate.id)
    end

    test "delete_backing_aggregate/1 deletes the backing_aggregate" do
      backing_aggregate = backing_aggregate_fixture()
      assert {:ok, %BackingAggregate{}} = Aggregate.delete_backing_aggregate(backing_aggregate)
      assert_raise Ecto.NoResultsError, fn -> Aggregate.get_backing_aggregate!(backing_aggregate.id) end
    end

    test "change_backing_aggregate/1 returns a backing_aggregate changeset" do
      backing_aggregate = backing_aggregate_fixture()
      assert %Ecto.Changeset{} = Aggregate.change_backing_aggregate(backing_aggregate)
    end
  end
end
