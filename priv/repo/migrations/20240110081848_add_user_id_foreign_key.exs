defmodule FyeoBackend.Repo.Migrations.AddUserIdForeignKey do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :user_id, references("users")
    end
  end
end
