defmodule Bike.Karoo.Supervisor do
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, opts},
      type: :supervisor
    }
  end

  @second 1000
  @minute @second * 60
  @hour @minute * 60
  @day @hour * 24

  def start_link() do
    children = [
      # The watcher populates the database
      {Bike.Karoo.Watcher, Application.get_env(:bike, Bike.Karoo.Watcher)[:rider_id]},
      # Garbage collector cleans up old data
      {Bike.Karoo.GarbageCollection, @hour},
      Bike.Karoo.Ride
    ]

    Supervisor.start_link(children, name: Bike.Karoo.Supervisor, strategy: :one_for_one)
  end
end
