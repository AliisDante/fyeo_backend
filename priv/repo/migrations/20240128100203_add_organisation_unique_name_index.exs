defmodule FyeoBackend.Repo.Migrations.AddOrganisationNameIndex do
  use Ecto.Migration

  def change do
    create unique_index("organisations", [:name])
  end
end
