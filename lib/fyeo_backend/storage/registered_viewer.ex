defmodule FyeoBackend.Storage.RegisteredViewer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registered_viewers" do
    field :registration_token, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(registered_viewer, attrs) do
    registered_viewer
    |> cast(attrs, [:registration_token])
    |> validate_required([:registration_token])
  end
end
