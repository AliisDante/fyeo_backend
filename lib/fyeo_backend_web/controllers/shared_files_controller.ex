defmodule FyeoBackendWeb.SharedFilesController do
  use FyeoBackendWeb, :controller
  alias ExAws.S3
  alias FyeoBackend.Storage

  def register_application(conn, _params) do
    registration_token = Base.encode64(:crypto.strong_rand_bytes(32))
    {:ok, _} = Storage.create_registered_viewer(%{registration_token: registration_token})

    render(conn, :registration, %{registration_token: registration_token})
  end

  def get_file(conn, %{"registration_token" => registration_token, "filename" => filename}) do
    with %Storage.RegisteredViewer{} <- Storage.get_registered_viewer_with_registration_token(registration_token),
         shared_file <- Storage.get_shared_file_with_external_id(filename),
         {:ok, %{body: file_data}} <- S3.get_object(Storage.get_bucket(), shared_file.external_id) |> ExAws.request,
         key <- Base.decode64(registration_token),
         iv <- :crypto.strong_rand_bytes(12),
         {encrypted_filedata, tag} <- :crypto.crypto_one_time_aead(:aes_256_gcm, key, iv, file_data, "", 16, true),
         encrypted_filedata <- Base.encode64(encrypted_filedata),
         tag <- Base.encode64(tag),
         iv <- Base.encode64(iv)
    do
      render(conn, :get_file, %{encrypted_filedata: encrypted_filedata, iv: iv, tag: tag})
    end
  end
end
