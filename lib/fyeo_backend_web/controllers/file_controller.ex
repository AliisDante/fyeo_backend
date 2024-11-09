defmodule FyeoBackendWeb.FileController do
  use FyeoBackendWeb, :controller
  alias FyeoBackend.Storage

  def get_file(conn, %{"file_id" => external_id}) do
    user_id = conn.assigns.user.id
    case Storage.get_file!(external_id) do
      %Storage.File{id: ^user_id} -> render(conn, :success, presigned_url: Storage.get_presigned_get_url!(external_id))
      _ -> render(conn, :error)
    end
  end
end
