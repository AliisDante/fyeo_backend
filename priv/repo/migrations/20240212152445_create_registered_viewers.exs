defmodule FyeoBackend.Repo.Migrations.CreateRegisteredViewers do
  use Ecto.Migration

  def change do
    create table(:registered_viewers) do
      add :registration_token, :string

      timestamps(type: :utc_datetime)
    end
  end
end
