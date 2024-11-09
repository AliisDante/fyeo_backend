defmodule FyeoBackend.StorageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FyeoBackend.Storage` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        external_id: "some external_id"
      })
      |> FyeoBackend.Storage.create_file()

    file
  end

  @doc """
  Generate a shared_file.
  """
  def shared_file_fixture(attrs \\ %{}) do
    {:ok, shared_file} =
      attrs
      |> Enum.into(%{
        external_id: "some external_id"
      })
      |> FyeoBackend.Storage.create_shared_file()

    shared_file
  end

  @doc """
  Generate a registered_viewer.
  """
  def registered_viewer_fixture(attrs \\ %{}) do
    {:ok, registered_viewer} =
      attrs
      |> Enum.into(%{
        registration_token: "some registration_token"
      })
      |> FyeoBackend.Storage.create_registered_viewer()

    registered_viewer
  end
end
