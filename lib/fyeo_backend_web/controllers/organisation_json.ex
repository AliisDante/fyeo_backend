defmodule FyeoBackendWeb.OrganisationJSON do
  def register(%{organisation: organisation}) do
    %{success: true, organisation_id: organisation.id}
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
