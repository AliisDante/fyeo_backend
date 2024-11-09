defmodule FyeoBackendWeb.UserController do
  use FyeoBackendWeb, :controller
  alias FyeoBackend.Accounts

  @moduledoc """
  Handles user registration
  """

  # def signup(conn, %{"password" => password, "confirm_password" => confirm_password} = params) when password === confirm_password do
  #   case Accounts.create_user(params) do
  #     {:ok, user} -> render(conn, :register, user: user)
  #     {:error, changeset} -> render(conn, :register, changeset: changeset)
  #   end
  # end

  # def signup(conn, %{"password" => _password, "confirm_password" => _confirm_password}) do
  #   render(conn, :register, error_message: "Passwords do not match")
  # end

  def login(conn, %{"username" => username, "password" => password}) do
    case Accounts.get_user_by_username_and_password(username, password) do
      %Accounts.User{} = user ->
        user_token = Accounts.generate_auth_token(user, FyeoBackendWeb.Endpoint)
        render(conn, :login, user_token: user_token)
      :error -> render(conn, :login, error_message: "Invalid username or password")
    end
  end

  # Experimental code for confirming email
  # def email(conn, %{"email_token" => email_token}) do
  #   render(conn, :email, token: email_token)
  # end

  # def confirm_email(conn, %{"email_token" => email_token}) do
  # end
end
