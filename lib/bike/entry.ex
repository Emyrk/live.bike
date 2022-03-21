defmodule Bike.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field(:avg_speed, :float)
    field(:battery_percent, :float)
    field(:bearing, :float)
    field(:elevation_gain, :float)
    field(:lat, :float)
    field(:lng, :float)
    field(:rider_name, :string)
    field(:state, :string)
    field(:time_elapsed, :float)
    field(:total_distance, :float)
    field(:json, :string)

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [
      :rider_name,
      :state,
      :lat,
      :lng,
      :bearing,
      :elevation_gain,
      :time_elapsed,
      :total_distance,
      :battery_percent,
      :avg_speed,
      :json
    ])
    |> validate_required([
      :rider_name,
      :state,
      :lat,
      :lng,
      :bearing,
      :elevation_gain,
      :time_elapsed,
      :total_distance,
      :battery_percent,
      :avg_speed
    ])
  end
end
