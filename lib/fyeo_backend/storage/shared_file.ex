defmodule FyeoBackend.Storage.SharedFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shared_files" do
    field :external_id, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shared_file, attrs) do
    shared_file
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
    |> unique_constraint(:external_id)
  end
end
