defmodule FyeoBackend.Accounts.Organisation do
  use Ecto.Schema
  import Ecto.Changeset
  alias FyeoBackend.Accounts.User

  @derive {Jason.Encoder, only: [:name]}
  schema "organisations" do
    field :name, :string
    has_many :users, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
