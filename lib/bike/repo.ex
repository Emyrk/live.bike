defmodule Bike.Repo do
  use Ecto.Repo,
    otp_app: :bike,
    # adapter: Ecto.Adapters.SQLite3
    adapter: Ecto.Adapters.Postgres
end
