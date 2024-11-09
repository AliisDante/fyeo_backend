defmodule FyeoBackendWeb.StorageChannel do
  use FyeoBackendWeb, :channel
  alias FyeoBackend.Storage

  def join("storage", _message, socket) do
    {:ok, socket}
  end

  def handle_in("upload_new", %{"encoded_filename" => encoded_filename} = _payload, socket) do
    presigned_post = Storage.get_presigned_post_url!(%{external_id: encoded_filename})
    {:reply, {:ok, presigned_post}, socket}
  end

  def handle_in("confirm_upload", %{"filename" => encoded_filename}, socket) do
    Storage.create_file(socket.assigns.user, %{external_id: encoded_filename})
    {:noreply, socket}
  end

  def handle_in("get_user_files", _payload, socket) do
    files = Storage.get_files_by_user(socket.assigns.user)
    {:reply, {:ok, files}, socket}
  end

  def handle_in("get_file_get_presigned_url", %{"filename" => encoded_filename} = _payload, socket) do
    file = Storage.get_file_and_validate_user(encoded_filename, socket.assigns.user)
    {:reply, {:ok, Storage.get_presigned_get_url!(file)}, socket}
  end

  def handle_in("get_file_head_presigned_url", %{"filename" => encoded_filename} = _payload, socket) do
    file = Storage.get_file_and_validate_user(encoded_filename, socket.assigns.user)
    {:reply, {:ok, Storage.get_presigned_head_url!(file)}, socket}
  end

  def handle_in("delete_file", %{"filename" => encoded_filename}, socket) do
    file = Storage.get_file_and_validate_user(encoded_filename, socket.assigns.user)
    {:reply, {:ok, Storage.get_presigned_delete_url!(file)}, socket}
  end

  def handle_in("confirm_delete", %{"filename" => encoded_filename}, socket) do
    file = Storage.get_file_and_validate_user(encoded_filename, socket.assigns.user)
    Storage.delete_file(file)
    {:noreply, socket}
  end

  def handle_in("confirm_share", %{"filename" => encoded_filename}, socket) do
    {:ok, _shared_file} = Storage.create_shared_file(%{external_id: encoded_filename})
    {:reply, :ok, socket}
  end
end
