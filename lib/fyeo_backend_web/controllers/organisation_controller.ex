defmodule FyeoBackendWeb.OrganisationController do
  use FyeoBackendWeb, :controller
  alias FyeoBackend.Accounts

  @moduledoc """
  Handles user registration
  """

  def signup(conn, %{"organisation_name" => organisation_name, "password" => password, "confirm_password" => confirm_password} = params) when password === confirm_password do
    params = Map.put_new(params, "name", organisation_name)
    case Accounts.create_organisation(params) do
      {:ok, organisation} -> render(conn, :register, organisation: organisation)
      {:error, changeset} -> render(conn, :register, changeset: changeset)
    end
  end

  def signup(conn, %{"password" => _password, "confirm_password" => _confirm_password}) do
    render(conn, :register, error_message: "Passwords do not match")
  end

  # Experimental code for confirming email
  # def email(conn, %{"email_token" => email_token}) do
  #   render(conn, :email, token: email_token)
  # end

  # def confirm_email(conn, %{"email_token" => email_token}) do
  # end
end
