defmodule FyeoBackend.AccountsTest do
  use FyeoBackend.DataCase

  alias FyeoBackend.Accounts

  describe "users" do
    alias FyeoBackend.Accounts.User

    import FyeoBackend.AccountsFixtures

    @invalid_attrs %{confirmed_at: nil, hashed_password: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{confirmed_at: ~N[2023-12-05 13:55:00], hashed_password: "some hashed_password", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.confirmed_at == ~N[2023-12-05 13:55:00]
      assert user.hashed_password == "some hashed_password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{confirmed_at: ~N[2023-12-06 13:55:00], hashed_password: "some updated hashed_password", username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.confirmed_at == ~N[2023-12-06 13:55:00]
      assert user.hashed_password == "some updated hashed_password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "organisations" do
    alias FyeoBackend.Accounts.Organisation

    import FyeoBackend.AccountsFixtures

    @invalid_attrs %{name: nil}

    test "list_organisations/0 returns all organisations" do
      organisation = organisation_fixture()
      assert Accounts.list_organisations() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Accounts.get_organisation!(organisation.id) == organisation
    end

    test "create_organisation/1 with valid data creates a organisation" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Organisation{} = organisation} = Accounts.create_organisation(valid_attrs)
      assert organisation.name == "some name"
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Organisation{} = organisation} = Accounts.update_organisation(organisation, update_attrs)
      assert organisation.name == "some updated name"
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organisation(organisation, @invalid_attrs)
      assert organisation == Accounts.get_organisation!(organisation.id)
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Accounts.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organisation(organisation)
    end
  end
end
