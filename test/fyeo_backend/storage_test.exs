defmodule FyeoBackend.StorageTest do
  use FyeoBackend.DataCase

  alias FyeoBackend.Storage

  describe "files" do
    alias FyeoBackend.Storage.File

    import FyeoBackend.StorageFixtures

    @invalid_attrs %{external_id: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Storage.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Storage.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{external_id: "some external_id"}

      assert {:ok, %File{} = file} = Storage.create_file(valid_attrs)
      assert file.external_id == "some external_id"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{external_id: "some updated external_id"}

      assert {:ok, %File{} = file} = Storage.update_file(file, update_attrs)
      assert file.external_id == "some updated external_id"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_file(file, @invalid_attrs)
      assert file == Storage.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Storage.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Storage.change_file(file)
    end
  end

  describe "shared_files" do
    alias FyeoBackend.Storage.SharedFile

    import FyeoBackend.StorageFixtures

    @invalid_attrs %{external_id: nil}

    test "list_shared_files/0 returns all shared_files" do
      shared_file = shared_file_fixture()
      assert Storage.list_shared_files() == [shared_file]
    end

    test "get_shared_file!/1 returns the shared_file with given id" do
      shared_file = shared_file_fixture()
      assert Storage.get_shared_file!(shared_file.id) == shared_file
    end

    test "create_shared_file/1 with valid data creates a shared_file" do
      valid_attrs = %{external_id: "some external_id"}

      assert {:ok, %SharedFile{} = shared_file} = Storage.create_shared_file(valid_attrs)
      assert shared_file.external_id == "some external_id"
    end

    test "create_shared_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_shared_file(@invalid_attrs)
    end

    test "update_shared_file/2 with valid data updates the shared_file" do
      shared_file = shared_file_fixture()
      update_attrs = %{external_id: "some updated external_id"}

      assert {:ok, %SharedFile{} = shared_file} = Storage.update_shared_file(shared_file, update_attrs)
      assert shared_file.external_id == "some updated external_id"
    end

    test "update_shared_file/2 with invalid data returns error changeset" do
      shared_file = shared_file_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_shared_file(shared_file, @invalid_attrs)
      assert shared_file == Storage.get_shared_file!(shared_file.id)
    end

    test "delete_shared_file/1 deletes the shared_file" do
      shared_file = shared_file_fixture()
      assert {:ok, %SharedFile{}} = Storage.delete_shared_file(shared_file)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_shared_file!(shared_file.id) end
    end

    test "change_shared_file/1 returns a shared_file changeset" do
      shared_file = shared_file_fixture()
      assert %Ecto.Changeset{} = Storage.change_shared_file(shared_file)
    end
  end

  describe "registered_viewers" do
    alias FyeoBackend.Storage.RegisteredViewer

    import FyeoBackend.StorageFixtures

    @invalid_attrs %{registration_token: nil}

    test "list_registered_viewers/0 returns all registered_viewers" do
      registered_viewer = registered_viewer_fixture()
      assert Storage.list_registered_viewers() == [registered_viewer]
    end

    test "get_registered_viewer!/1 returns the registered_viewer with given id" do
      registered_viewer = registered_viewer_fixture()
      assert Storage.get_registered_viewer!(registered_viewer.id) == registered_viewer
    end

    test "create_registered_viewer/1 with valid data creates a registered_viewer" do
      valid_attrs = %{registration_token: "some registration_token"}

      assert {:ok, %RegisteredViewer{} = registered_viewer} = Storage.create_registered_viewer(valid_attrs)
      assert registered_viewer.registration_token == "some registration_token"
    end

    test "create_registered_viewer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_registered_viewer(@invalid_attrs)
    end

    test "update_registered_viewer/2 with valid data updates the registered_viewer" do
      registered_viewer = registered_viewer_fixture()
      update_attrs = %{registration_token: "some updated registration_token"}

      assert {:ok, %RegisteredViewer{} = registered_viewer} = Storage.update_registered_viewer(registered_viewer, update_attrs)
      assert registered_viewer.registration_token == "some updated registration_token"
    end

    test "update_registered_viewer/2 with invalid data returns error changeset" do
      registered_viewer = registered_viewer_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_registered_viewer(registered_viewer, @invalid_attrs)
      assert registered_viewer == Storage.get_registered_viewer!(registered_viewer.id)
    end

    test "delete_registered_viewer/1 deletes the registered_viewer" do
      registered_viewer = registered_viewer_fixture()
      assert {:ok, %RegisteredViewer{}} = Storage.delete_registered_viewer(registered_viewer)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_registered_viewer!(registered_viewer.id) end
    end

    test "change_registered_viewer/1 returns a registered_viewer changeset" do
      registered_viewer = registered_viewer_fixture()
      assert %Ecto.Changeset{} = Storage.change_registered_viewer(registered_viewer)
    end
  end
end
