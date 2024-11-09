defmodule FyeoBackendWeb.UserPlugs do
  @moduledoc """
  Plugs for handling users
  """
  import Plug.Conn

  alias FyeoBackend.Accounts

  def fetch_user(%Plug.Conn{body_params: %{"token" => token}} = conn, _opts) do
    case Accounts.validate_auth_token(token, FyeoBackendWeb.Endpoint) do
      {:ok, user_id} ->
      user = Accounts.get_user!(user_id)
      assign(conn, :user, user)
      _ -> conn
    end
  end

  def enforce_authenticated_user(%Plug.Conn{assigns: %{user: _user}} = conn, _opts) do
    conn
  end

  def enforce_authenticated_user(%Plug.Conn{} = conn, _opts) do
    conn
    |> halt()
    |> send_resp(403, Jason.encode_to_iodata!(%{error: true, error_message: "No user"}))
  end
end
