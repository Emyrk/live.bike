# A Ride is the actual list of Entries associated with a given ride.
# If a rider is riding, this is the API surface to display the ride.
# If the rider is idle, this will indicate that the ride is currently idle.
defmodule Bike.Karoo.Ride do
  use GenServer
  import Ecto.Query
  require Logger

  @pid_name :ride_tracker

  # Client
  def start_link(_params) do
    Logger.info("Starting new ride tracker")
    {:ok, pid} = GenServer.start_link(__MODULE__, [], name: @pid_name)
    {:ok, pid}
  end

  def send_event(entry) do
    GenServer.cast(@pid_name, {:add_entry, entry})
  end

  def list do
    GenServer.call(@pid_name, :list)
  end

  # Server

  @impl true
  def init(_params) do
    {:ok, %{ride: []}, {:continue, :load_db}}
  end

  # Server
  @impl true
  def handle_continue(:load_db, state) do
    # Loads the initial state from the DB. This will fetch a ride if it is in progress.
    now = DateTime.new!(~D[2022-03-20], ~T[20:29:18], "Etc/UTC")
    lastID = query_last_idle_id(now)
    ride = ongoing_ride(lastID, now)

    updated_state = Map.put(state, :ride, ride)
    {:noreply, updated_state}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state.ride, state}
  end

  @impl true
  def handle_cast({:add_entry, e}, state) do
    entry = %{
      id: e.id,
      rider_name: e.rider_name,
      state: e.state,
      lat: e.lat,
      lng: e.lng,
      bearing: e.bearing,
      elevation_gain: e.elevation_gain,
      time_elapsed: e.time_elapsed,
      total_distance: e.total_distance,
      battery_percent: e.battery_percent,
      avg_speed: e.avg_speed
    }

    entries = [entry | state.ride]
    Map.put(state, :ride, entries)
    Logger.info("New entry was saved in the tracker")

    {:noreply, state}
  end

  # Bike.Karoo.Ride.ongoing_ride(6400)
  def ongoing_ride(last_idle_id, now \\ DateTime.now!("Etc/UTC")) do
    query =
      from(e in "entries",
        select: %{
          id: e.id,
          rider_name: e.rider_name,
          state: e.state,
          lat: e.lat,
          lng: e.lng,
          bearing: e.bearing,
          elevation_gain: e.elevation_gain,
          time_elapsed: e.time_elapsed,
          total_distance: e.total_distance,
          battery_percent: e.battery_percent,
          avg_speed: e.avg_speed
        },
        order_by: [desc: :updated_at],
        where: e.id > ^last_idle_id,
        where: e.updated_at < ^now,
        where: e.state != "idle"
      )

    Bike.Repo.all(query)
  end

  # query_last_idle_id returns the id of the last row that is idle. All rows after this are an active ride that is ongoing.
  # DateTime.new!(~D[2022-03-20], ~T[20:29:18], "Etc/UTC")
  # Bike.Karoo.Ride.query_last_idle_id(DateTime.new!(~D[2022-03-20], ~T[20:29:18], "Etc/UTC"))
  # Bike.Karoo.Ride.query_last_idle_id(DateTime.new!(~D[2021-03-20], ~T[20:29:18], "Etc/UTC"))
  # Bike.Karoo.Ride.query_last_idle_id()
  def query_last_idle_id(now \\ DateTime.now!("Etc/UTC")) do
    query =
      from(e in "entries",
        select: %{id: e.id},
        order_by: [desc: :updated_at],
        where: e.state == "idle",
        where: e.updated_at < ^now,
        limit: 1
      )

    lastIdle = Bike.Repo.all(query)

    case length(lastIdle) do
      1 ->
        %{id: id} = hd(lastIdle)
        id

      0 ->
        0
    end
  end
end
