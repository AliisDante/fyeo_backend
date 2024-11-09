defmodule FyeoBackend.Repo.Migrations.CreateSharedFiles do
  use Ecto.Migration

  def change do
    create table(:shared_files) do
      add :external_id, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:shared_files, [:user_id])
  end
end
