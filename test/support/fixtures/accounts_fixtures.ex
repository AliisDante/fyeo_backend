defmodule FyeoBackend.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FyeoBackend.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        confirmed_at: ~N[2023-12-05 13:55:00],
        hashed_password: "some hashed_password",
        username: "some username"
      })
      |> FyeoBackend.Accounts.create_user()

    user
  end

  @doc """
  Generate a organisation.
  """
  def organisation_fixture(attrs \\ %{}) do
    {:ok, organisation} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> FyeoBackend.Accounts.create_organisation()

    organisation
  end
end
