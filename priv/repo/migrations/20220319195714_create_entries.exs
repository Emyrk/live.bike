defmodule Bike.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :rider_name, :string
      add :state, :string
      add :lat, :float
      add :lng, :float
      add :bearing, :float
      add :elevation_gain, :float
      add :time_elapsed, :float
      add :total_distance, :float
      add :battery_percent, :float
      add :avg_speed, :float

      timestamps()
    end
  end
end
