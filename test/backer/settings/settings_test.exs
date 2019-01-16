defmodule Backer.SettingsTest do
  use Backer.DataCase

  alias Backer.Settings

  describe "general_settings" do
    alias Backer.Settings.Setting

    @valid_attrs %{group: "some group", key: "some key", value: "some value"}
    @update_attrs %{
      group: "some updated group",
      key: "some updated key",
      value: "some updated value"
    }
    @invalid_attrs %{group: nil, key: nil, value: nil}

    def setting_fixture(attrs \\ %{}) do
      {:ok, setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_setting()

      setting
    end

    test "list_general_settings/0 returns all general_settings" do
      setting = setting_fixture()
      assert Settings.list_general_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Settings.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      assert {:ok, %Setting{} = setting} = Settings.create_setting(@valid_attrs)
      assert setting.group == "some group"
      assert setting.key == "some key"
      assert setting.value == "some value"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      assert {:ok, setting} = Settings.update_setting(setting, @update_attrs)
      assert %Setting{} = setting
      assert setting.group == "some updated group"
      assert setting.key == "some updated key"
      assert setting.value == "some updated value"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_setting(setting, @invalid_attrs)
      assert setting == Settings.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Settings.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Settings.change_setting(setting)
    end
  end
end
