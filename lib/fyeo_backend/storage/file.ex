defmodule FyeoBackend.Storage.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias FyeoBackend.Accounts

  @derive {Jason.Encoder, only: [:external_id]}
  schema "files" do
    field :external_id, :string
    belongs_to :user, Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:external_id])
    |> validate_required([:external_id])
  end

  @doc false
  def changeset_user(file, %Accounts.User{} = user) do
    file
    |> change(%{user_id: user.id})
  end
end
