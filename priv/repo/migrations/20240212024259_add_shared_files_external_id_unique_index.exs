defmodule FyeoBackend.Repo.Migrations.AddSharedFilesExternalIdUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index("shared_files", [:external_id])
  end
end
