defmodule FyeoBackend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias FyeoBackend.Repo

  alias FyeoBackend.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username_and_password(username, password) do
    with %User{hashed_password: hashed_password} = user <- get_user_by_username(username),
         true <- Argon2.verify_pass(password, hashed_password)
    do
      user
    else
      _ ->
        Argon2.no_user_verify()
        :error
    end
  end

  def get_user_by_username(username) do
    q = from u in User, where: u.username == ^username
    Repo.one(q)
  end

  @doc """
  Creates a user and fill in relevant information from another existing user. E.g. organisation data

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(cast_attrs, reference_user, change_attrs \\ %{})

  def create_user(cast_attrs, nil, change_attrs) do
    do_create_user(cast_attrs, change_attrs)
  end

  def create_user(cast_attrs, reference_user, change_attrs) do
    reference_user = Repo.preload reference_user, :organisation

    referenced_fields = %{organisation_id: reference_user.organisation.id}
    full_change_attrs = Map.merge(referenced_fields, change_attrs)

    do_create_user(cast_attrs, full_change_attrs)
  end

  def do_create_user(cast_attrs \\ %{}, change_attrs \\ %{}) do
    %User{}
    |> User.changeset(cast_attrs)
    |> change(change_attrs)
    |> Repo.insert()
  end

  @doc """
  Load the organisation field of an user schema
  """
  def load_user_organisation(%User{} = user) do
    Repo.preload(user, :organisation)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  # Experimental code for confirming email
  # def generate_email_confirmation_token(%User{} = user, context) do
  #   Phoenix.Token.sign(context, "email_confirmation", user.id)
  # end

  # def validate_email_confirmation_token(token, context) do
  #   case Phoenix.Token.verify(context, "email_confirmation", token) do
  #     {:ok, user_id}
  #   end
  # end
  #

  def generate_auth_token(%User{} = user, context) do
    Phoenix.Token.sign(context, "auth_token", user.id)
  end

  def validate_auth_token(token, context) do
    Phoenix.Token.verify(context, "auth_token", token)
  end

  alias FyeoBackend.Accounts.Organisation

  @doc """
  Returns the list of organisations.

  ## Examples

      iex> list_organisations()
      [%Organisation{}, ...]

  """
  def list_organisations do
    Repo.all(Organisation)
  end

  @doc """
  Gets a single organisation.

  Raises `Ecto.NoResultsError` if the Organisation does not exist.

  ## Examples

      iex> get_organisation!(123)
      %Organisation{}

      iex> get_organisation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organisation!(id), do: Repo.get!(Organisation, id)

  @doc """
  Creates a organisation.

  ## Examples

      iex> create_organisation(%{field: value})
      {:ok, %Organisation{}}

      iex> create_organisation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organisation(attrs \\ %{}) do
    Repo.transaction(fn ->
      new_organisation = %Organisation{}
      |> Organisation.changeset(attrs)
      |> Repo.insert!()

      {:ok, initial_admin} = create_user(attrs, nil, %{organisation_id: new_organisation.id, is_admin: true})

      initial_admin
    end)
  end

  @doc """
  Updates a organisation.

  ## Examples

      iex> update_organisation(organisation, %{field: new_value})
      {:ok, %Organisation{}}

      iex> update_organisation(organisation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organisation(%Organisation{} = organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organisation.

  ## Examples

      iex> delete_organisation(organisation)
      {:ok, %Organisation{}}

      iex> delete_organisation(organisation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organisation(%Organisation{} = organisation) do
    Repo.delete(organisation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organisation changes.

  ## Examples

      iex> change_organisation(organisation)
      %Ecto.Changeset{data: %Organisation{}}

  """
  def change_organisation(%Organisation{} = organisation, attrs \\ %{}) do
    Organisation.changeset(organisation, attrs)
  end

  @doc """
  Load the users field of an organisation schema
  """
  def load_organisation_users(%Organisation{} = organisation) do
    Repo.preload(organisation, :users)
  end
end
