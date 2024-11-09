defmodule FyeoBackend.Storage do
  @moduledoc """
  The Storage context.
  """

  import Ecto.Query, warn: false
  alias FyeoBackend.Repo

  alias FyeoBackend.Storage.File
  alias FyeoBackend.Accounts

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(user, attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> File.changeset_user(user)
    |> Repo.insert()
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end

  @doc """
  Get files for a specific user
  """
  def get_files_by_user(%Accounts.User{} = user) do
    q = from f in File, where: f.user_id == ^user.id
    Repo.all(q)
  end

  @doc """
  Get a file by external_id and verifies that it belongs to a specific user
  """
  def get_file_and_validate_user(external_id, %Accounts.User{} = user) do
    q = from f in File, where: f.user_id == ^user.id and f.external_id == ^external_id
    Repo.one(q)
  end

  @doc """
  Return the relevant AWS bucket for the application
  """
  def get_bucket() do
    bucket = Application.fetch_env!(:fyeo_backend, :aws)
             |> Keyword.fetch!(:bucket)
  end

  @doc """
  Returns a presigned url for independent access with the provided HTTP method
  """
  defp generate_presigned_url!(method, %File{external_id: external_id}) do
    bucket = get_bucket()
    config = ExAws.Config.new(:s3, [])

    case ExAws.S3.presigned_url(config, method, bucket, external_id, virtual_host: true) do
      {:ok, url} -> url
      {:error, _message} -> raise ExAws.Error
    end
  end

  @doc """
  Returns a presigned url for independent access with the POST HTTP method
  """
  defp generate_post_url!(%{external_id: external_id}) do
    bucket = get_bucket()
    config = ExAws.Config.new(:s3, [])

    ExAws.S3.presigned_post(config, bucket, external_id, custom_conditions: [["starts-with", "$x-amz-meta-e2ee-iv", ""]])
  end

  @doc """
  Returns a presigned url for GET access
  """
  def get_presigned_get_url!(%File{} = file) do
    generate_presigned_url!(:get, file)
  end

  @doc """
  Returns a presigned url for PUT access
  """
  def get_presigned_put_url!(%File{} = file) do
    generate_presigned_url!(:put, file)
  end

  @doc """
  Returns a presigned url for DELETE access
  """
  def get_presigned_delete_url!(%File{} = file) do
    generate_presigned_url!(:delete, file)
  end

  @doc """
  Returns a presigned url for HEAD access
  """
  def get_presigned_head_url!(%File{} = file) do
    generate_presigned_url!(:head, file)
  end

  @doc """
  Returns a presigned url for POST access
  """
  def get_presigned_post_url!(file) when is_map(file) do
    generate_post_url!(file)
  end

  alias FyeoBackend.Storage.SharedFile

  @doc """
  Returns the list of shared_files.

  ## Examples

      iex> list_shared_files()
      [%SharedFile{}, ...]

  """
  def list_shared_files do
    Repo.all(SharedFile)
  end

  @doc """
  Gets a single shared_file.

  Raises `Ecto.NoResultsError` if the Shared file does not exist.

  ## Examples

      iex> get_shared_file!(123)
      %SharedFile{}

      iex> get_shared_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shared_file!(id), do: Repo.get!(SharedFile, id)

  @doc """
  Get shared file using external_id
  """
  def get_shared_file_with_external_id(external_id) do
    q = from s in SharedFile, where: s.external_id == ^external_id
    Repo.one(q)
  end

  @doc """
  Creates a shared_file.

  ## Examples

      iex> create_shared_file(%{field: value})
      {:ok, %SharedFile{}}

      iex> create_shared_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shared_file(attrs \\ %{}) do
    %SharedFile{}
    |> SharedFile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shared_file.

  ## Examples

      iex> update_shared_file(shared_file, %{field: new_value})
      {:ok, %SharedFile{}}

      iex> update_shared_file(shared_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shared_file(%SharedFile{} = shared_file, attrs) do
    shared_file
    |> SharedFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shared_file.

  ## Examples

      iex> delete_shared_file(shared_file)
      {:ok, %SharedFile{}}

      iex> delete_shared_file(shared_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shared_file(%SharedFile{} = shared_file) do
    Repo.delete(shared_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shared_file changes.

  ## Examples

      iex> change_shared_file(shared_file)
      %Ecto.Changeset{data: %SharedFile{}}

  """
  def change_shared_file(%SharedFile{} = shared_file, attrs \\ %{}) do
    SharedFile.changeset(shared_file, attrs)
  end

  alias FyeoBackend.Storage.RegisteredViewer

  @doc """
  Returns the list of registered_viewers.

  ## Examples

      iex> list_registered_viewers()
      [%RegisteredViewer{}, ...]

  """
  def list_registered_viewers do
    Repo.all(RegisteredViewer)
  end

  @doc """
  Gets a single registered_viewer.

  Raises `Ecto.NoResultsError` if the Registered viewer does not exist.

  ## Examples

      iex> get_registered_viewer!(123)
      %RegisteredViewer{}

      iex> get_registered_viewer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_registered_viewer!(id), do: Repo.get!(RegisteredViewer, id)

  def get_registered_viewer_with_registration_token(registration_token) do
    q = from r in RegisteredViewer, where: r.registration_token == ^registration_token
    Repo.one(q)
  end

  @doc """
  Creates a registered_viewer.

  ## Examples

      iex> create_registered_viewer(%{field: value})
      {:ok, %RegisteredViewer{}}

      iex> create_registered_viewer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_registered_viewer(attrs \\ %{}) do
    %RegisteredViewer{}
    |> RegisteredViewer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a registered_viewer.

  ## Examples

      iex> update_registered_viewer(registered_viewer, %{field: new_value})
      {:ok, %RegisteredViewer{}}

      iex> update_registered_viewer(registered_viewer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_registered_viewer(%RegisteredViewer{} = registered_viewer, attrs) do
    registered_viewer
    |> RegisteredViewer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a registered_viewer.

  ## Examples

      iex> delete_registered_viewer(registered_viewer)
      {:ok, %RegisteredViewer{}}

      iex> delete_registered_viewer(registered_viewer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_registered_viewer(%RegisteredViewer{} = registered_viewer) do
    Repo.delete(registered_viewer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking registered_viewer changes.

  ## Examples

      iex> change_registered_viewer(registered_viewer)
      %Ecto.Changeset{data: %RegisteredViewer{}}

  """
  def change_registered_viewer(%RegisteredViewer{} = registered_viewer, attrs \\ %{}) do
    RegisteredViewer.changeset(registered_viewer, attrs)
  end
end
