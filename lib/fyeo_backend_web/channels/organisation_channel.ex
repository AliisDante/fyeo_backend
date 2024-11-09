defmodule FyeoBackendWeb.OrganisationChannel do
  use FyeoBackendWeb, :channel
  alias FyeoBackend.Accounts

  def join("organisation", _message, socket) do
    case socket.assigns.user do
      %Accounts.User{is_admin: true} -> {:ok, socket}
      _ -> {:error, %{reason: "Not administrator"}}
    end
  end

  def process_checkbox(data, field) do
    case Map.get(data, field, false) do
      false -> false
      _ -> true
    end
  end

  def handle_in("create_user", %{"password" => password, "confirm_password" => password} = data, socket) do
    is_admin = process_checkbox(data, "is_admin")

    reply = case Accounts.create_user(data, socket.assigns.user, %{is_admin: is_admin}) do
      {:ok, user} -> {:ok, user.id}
      {:error, %Ecto.Changeset{errors: [first_error | _]}} ->
        {error_field, {error_message, _}} = first_error
        full_error_message = "#{error_field} #{error_message}"
        {:error, full_error_message}
      _ -> {:error, "Unknown error"}
    end

    {:reply, reply, socket}
  end

  def handle_in("get_users", _payload, socket) do
    user = socket.assigns.user
    organisation = user.organisation |> Accounts.load_organisation_users()
    {:reply, {:ok, organisation.users}, socket}
  end

  def handle_in("delete_user", username, socket) do
    current_user = socket.assigns.user
    user_to_delete = Accounts.get_user_by_username(username) |> Accounts.load_user_organisation()
    if user_to_delete.organisation == current_user.organisation do
      Accounts.delete_user(user_to_delete)
    end

    {:reply, :ok, socket}
  end
end
