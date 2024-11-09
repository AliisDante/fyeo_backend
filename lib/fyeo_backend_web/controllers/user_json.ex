defmodule FyeoBackendWeb.UserJSON do
  def login(%{user_token: user_token}) do
    %{success: true, user_token: user_token}
  end

  def login(%{error_message: error_message}) do
    %{error: true, error_message: error_message}
  end

  def register(%{user: user}) do
    %{success: true, user_id: user.id}
  end

  def register(%{changeset: %{errors: [first_error | _]}}) do
    {error_field, {error_message, _}} = first_error
    full_error_message = "#{error_field} #{error_message}"
    %{error: true, error_message: full_error_message}
  end

  def register(%{error_message: error_message}) do
    %{error: true, error_message: error_message}
  end
end
