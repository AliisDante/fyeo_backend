defmodule FyeoBackend.Repo do
  use Ecto.Repo,
    otp_app: :fyeo_backend,
    adapter: Ecto.Adapters.SQLite3
end
