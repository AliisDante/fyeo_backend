defmodule FyeoBackend.Repo.Migrations.AddOrganisationUserRelationship do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :organisation_id, references("organisations")
    end
  end
end
