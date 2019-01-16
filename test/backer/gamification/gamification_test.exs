defmodule Backer.GamificationTest do
  use Backer.DataCase

  alias Backer.Gamification

  describe "badges" do
    alias Backer.Gamification.Badge

    @valid_attrs %{description: "some description", icon: "some icon", title: "some title"}
    @update_attrs %{
      description: "some updated description",
      icon: "some updated icon",
      title: "some updated title"
    }
    @invalid_attrs %{description: nil, icon: nil, title: nil}

    def badge_fixture(attrs \\ %{}) do
      {:ok, badge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gamification.create_badge()

      badge
    end

    test "list_badges/0 returns all badges" do
      badge = badge_fixture()
      assert Gamification.list_badges() == [badge]
    end

    test "get_badge!/1 returns the badge with given id" do
      badge = badge_fixture()
      assert Gamification.get_badge!(badge.id) == badge
    end

    test "create_badge/1 with valid data creates a badge" do
      assert {:ok, %Badge{} = badge} = Gamification.create_badge(@valid_attrs)
      assert badge.description == "some description"
      assert badge.icon == "some icon"
      assert badge.title == "some title"
    end

    test "create_badge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_badge(@invalid_attrs)
    end

    test "update_badge/2 with valid data updates the badge" do
      badge = badge_fixture()
      assert {:ok, badge} = Gamification.update_badge(badge, @update_attrs)
      assert %Badge{} = badge
      assert badge.description == "some updated description"
      assert badge.icon == "some updated icon"
      assert badge.title == "some updated title"
    end

    test "update_badge/2 with invalid data returns error changeset" do
      badge = badge_fixture()
      assert {:error, %Ecto.Changeset{}} = Gamification.update_badge(badge, @invalid_attrs)
      assert badge == Gamification.get_badge!(badge.id)
    end

    test "delete_badge/1 deletes the badge" do
      badge = badge_fixture()
      assert {:ok, %Badge{}} = Gamification.delete_badge(badge)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_badge!(badge.id) end
    end

    test "change_badge/1 returns a badge changeset" do
      badge = badge_fixture()
      assert %Ecto.Changeset{} = Gamification.change_badge(badge)
    end
  end

  describe "badge_members" do
    alias Backer.Gamification.BadgeMember

    @valid_attrs %{award_date: ~D[2010-04-17]}
    @update_attrs %{award_date: ~D[2011-05-18]}
    @invalid_attrs %{award_date: nil}

    def badge_member_fixture(attrs \\ %{}) do
      {:ok, badge_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gamification.create_badge_member()

      badge_member
    end

    test "list_badge_members/0 returns all badge_members" do
      badge_member = badge_member_fixture()
      assert Gamification.list_badge_members() == [badge_member]
    end

    test "get_badge_member!/1 returns the badge_member with given id" do
      badge_member = badge_member_fixture()
      assert Gamification.get_badge_member!(badge_member.id) == badge_member
    end

    test "create_badge_member/1 with valid data creates a badge_member" do
      assert {:ok, %BadgeMember{} = badge_member} = Gamification.create_badge_member(@valid_attrs)
      assert badge_member.award_date == ~D[2010-04-17]
    end

    test "create_badge_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_badge_member(@invalid_attrs)
    end

    test "update_badge_member/2 with valid data updates the badge_member" do
      badge_member = badge_member_fixture()
      assert {:ok, badge_member} = Gamification.update_badge_member(badge_member, @update_attrs)
      assert %BadgeMember{} = badge_member
      assert badge_member.award_date == ~D[2011-05-18]
    end

    test "update_badge_member/2 with invalid data returns error changeset" do
      badge_member = badge_member_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Gamification.update_badge_member(badge_member, @invalid_attrs)

      assert badge_member == Gamification.get_badge_member!(badge_member.id)
    end

    test "delete_badge_member/1 deletes the badge_member" do
      badge_member = badge_member_fixture()
      assert {:ok, %BadgeMember{}} = Gamification.delete_badge_member(badge_member)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_badge_member!(badge_member.id) end
    end

    test "change_badge_member/1 returns a badge_member changeset" do
      badge_member = badge_member_fixture()
      assert %Ecto.Changeset{} = Gamification.change_badge_member(badge_member)
    end
  end

  describe "points" do
    alias Backer.Gamification.Point

    @valid_attrs %{point: 42, refference: 42, type: "some type"}
    @update_attrs %{point: 43, refference: 43, type: "some updated type"}
    @invalid_attrs %{point: nil, refference: nil, type: nil}

    def point_fixture(attrs \\ %{}) do
      {:ok, point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gamification.create_point()

      point
    end

    test "list_points/0 returns all points" do
      point = point_fixture()
      assert Gamification.list_points() == [point]
    end

    test "get_point!/1 returns the point with given id" do
      point = point_fixture()
      assert Gamification.get_point!(point.id) == point
    end

    test "create_point/1 with valid data creates a point" do
      assert {:ok, %Point{} = point} = Gamification.create_point(@valid_attrs)
      assert point.point == 42
      assert point.refference == 42
      assert point.type == "some type"
    end

    test "create_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_point(@invalid_attrs)
    end

    test "update_point/2 with valid data updates the point" do
      point = point_fixture()
      assert {:ok, point} = Gamification.update_point(point, @update_attrs)
      assert %Point{} = point
      assert point.point == 43
      assert point.refference == 43
      assert point.type == "some updated type"
    end

    test "update_point/2 with invalid data returns error changeset" do
      point = point_fixture()
      assert {:error, %Ecto.Changeset{}} = Gamification.update_point(point, @invalid_attrs)
      assert point == Gamification.get_point!(point.id)
    end

    test "delete_point/1 deletes the point" do
      point = point_fixture()
      assert {:ok, %Point{}} = Gamification.delete_point(point)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_point!(point.id) end
    end

    test "change_point/1 returns a point changeset" do
      point = point_fixture()
      assert %Ecto.Changeset{} = Gamification.change_point(point)
    end
  end
end
