defmodule FyeoBackend.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :external_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
