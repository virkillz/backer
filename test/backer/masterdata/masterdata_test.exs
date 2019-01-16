defmodule Backer.MasterdataTest do
  use Backer.DataCase

  alias Backer.Masterdata

  describe "categories" do
    alias Backer.Masterdata.Category

    @valid_attrs %{
      background: "some background",
      description: "some description",
      is_active: true,
      name: "some name"
    }
    @update_attrs %{
      background: "some updated background",
      description: "some updated description",
      is_active: false,
      name: "some updated name"
    }
    @invalid_attrs %{background: nil, description: nil, is_active: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Masterdata.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Masterdata.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Masterdata.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Masterdata.create_category(@valid_attrs)
      assert category.background == "some background"
      assert category.description == "some description"
      assert category.is_active == true
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Masterdata.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Masterdata.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.background == "some updated background"
      assert category.description == "some updated description"
      assert category.is_active == false
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Masterdata.update_category(category, @invalid_attrs)
      assert category == Masterdata.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Masterdata.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Masterdata.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Masterdata.change_category(category)
    end
  end

  describe "titles" do
    alias Backer.Masterdata.Title

    @valid_attrs %{description: "some description", is_active: true, name: "some name"}
    @update_attrs %{
      description: "some updated description",
      is_active: false,
      name: "some updated name"
    }
    @invalid_attrs %{description: nil, is_active: nil, name: nil}

    def title_fixture(attrs \\ %{}) do
      {:ok, title} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Masterdata.create_title()

      title
    end

    test "list_titles/0 returns all titles" do
      title = title_fixture()
      assert Masterdata.list_titles() == [title]
    end

    test "get_title!/1 returns the title with given id" do
      title = title_fixture()
      assert Masterdata.get_title!(title.id) == title
    end

    test "create_title/1 with valid data creates a title" do
      assert {:ok, %Title{} = title} = Masterdata.create_title(@valid_attrs)
      assert title.description == "some description"
      assert title.is_active == true
      assert title.name == "some name"
    end

    test "create_title/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Masterdata.create_title(@invalid_attrs)
    end

    test "update_title/2 with valid data updates the title" do
      title = title_fixture()
      assert {:ok, title} = Masterdata.update_title(title, @update_attrs)
      assert %Title{} = title
      assert title.description == "some updated description"
      assert title.is_active == false
      assert title.name == "some updated name"
    end

    test "update_title/2 with invalid data returns error changeset" do
      title = title_fixture()
      assert {:error, %Ecto.Changeset{}} = Masterdata.update_title(title, @invalid_attrs)
      assert title == Masterdata.get_title!(title.id)
    end

    test "delete_title/1 deletes the title" do
      title = title_fixture()
      assert {:ok, %Title{}} = Masterdata.delete_title(title)
      assert_raise Ecto.NoResultsError, fn -> Masterdata.get_title!(title.id) end
    end

    test "change_title/1 returns a title changeset" do
      title = title_fixture()
      assert %Ecto.Changeset{} = Masterdata.change_title(title)
    end
  end

  describe "tiers" do
    alias Backer.Masterdata.Tier

    @valid_attrs %{amount: 42, description: "some description", title: "some title"}
    @update_attrs %{
      amount: 43,
      description: "some updated description",
      title: "some updated title"
    }
    @invalid_attrs %{amount: nil, description: nil, title: nil}

    def tier_fixture(attrs \\ %{}) do
      {:ok, tier} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Masterdata.create_tier()

      tier
    end

    test "list_tiers/0 returns all tiers" do
      tier = tier_fixture()
      assert Masterdata.list_tiers() == [tier]
    end

    test "get_tier!/1 returns the tier with given id" do
      tier = tier_fixture()
      assert Masterdata.get_tier!(tier.id) == tier
    end

    test "create_tier/1 with valid data creates a tier" do
      assert {:ok, %Tier{} = tier} = Masterdata.create_tier(@valid_attrs)
      assert tier.amount == 42
      assert tier.description == "some description"
      assert tier.title == "some title"
    end

    test "create_tier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Masterdata.create_tier(@invalid_attrs)
    end

    test "update_tier/2 with valid data updates the tier" do
      tier = tier_fixture()
      assert {:ok, tier} = Masterdata.update_tier(tier, @update_attrs)
      assert %Tier{} = tier
      assert tier.amount == 43
      assert tier.description == "some updated description"
      assert tier.title == "some updated title"
    end

    test "update_tier/2 with invalid data returns error changeset" do
      tier = tier_fixture()
      assert {:error, %Ecto.Changeset{}} = Masterdata.update_tier(tier, @invalid_attrs)
      assert tier == Masterdata.get_tier!(tier.id)
    end

    test "delete_tier/1 deletes the tier" do
      tier = tier_fixture()
      assert {:ok, %Tier{}} = Masterdata.delete_tier(tier)
      assert_raise Ecto.NoResultsError, fn -> Masterdata.get_tier!(tier.id) end
    end

    test "change_tier/1 returns a tier changeset" do
      tier = tier_fixture()
      assert %Ecto.Changeset{} = Masterdata.change_tier(tier)
    end
  end
end
