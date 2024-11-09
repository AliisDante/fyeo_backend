defmodule FyeoBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias FyeoBackend.Storage
  alias FyeoBackend.Accounts.Organisation

  @derive {Jason.Encoder, only: [:username, :updated_at]}
  schema "users" do
    field :username, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime
    field :is_admin, :boolean
    has_many :files, Storage.File
    belongs_to :organisation, Organisation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_format(:password, ~r/(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}/, message: "does not fit password requirements")
    |> maybe_hash_password(attrs)
    |> validate_required([:username, :hashed_password])
    |> unique_constraint(:username)
  end

  def maybe_hash_password(user, %{"password" => password}) do
    hashed_password = Argon2.hash_pwd_salt(password)
    change(user, hashed_password: hashed_password)
  end
end
