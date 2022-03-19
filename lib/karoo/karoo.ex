defmodule Karoo.Watcher do
  use GenServer
  require Logger

  # Client

  # Karoo.start_link("rwUtCs7G")
  def start_link(id) do
    {:ok, pid} = GenServer.start_link(__MODULE__, id)
    GenServer.cast(pid, :start)
    {:ok, pid}
  end

  # State
  #   rider: Karoo.Rider

  # Server

  @impl true
  def init(id) do
    {:ok, rider} = Karoo.Rider.start_link(id)
    {:ok, %{rider: rider}}
  end

  @impl true
  def handle_cast(:start, state) do
    Process.send(self(), :poll_activity, [])
    {:noreply, state}
  end

  @impl true
  def handle_info(:poll_activity, state) do
    # poll_activity will poll the rider's activity
    poll_activity(state)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :poll_activity, 5000)
  end

  defp poll_activity(state) do
    %{rider: rider} = state

    case Karoo.Rider.activity(rider) do
      {:ok, activity} ->
        IO.inspect(activity)

      {:error, reason} ->
        Logger.error("Polling failed: #{reason}")
    end
  end
end

defmodule Karoo.Rider do
  @moduledoc """
  This module controls the functions to retrieve information about a given rider.
  The module is an Agent, and should be instantiated with 'Karoo.Rider.start_link/1' with the
  Karoo rider ID for live tracking.
  """
  use Agent

  # rwUtCs7G
  def start_link(id) do
    Agent.start_link(fn -> %{id: id} end)
  end

  def id(agent) do
    # & &1.id is shorthand for the anonymous function that returns ".id" of the first argument
    Agent.get(agent, & &1.id)
  end

  def activity(agent) do
    Karoo.Fetch.activity(id(agent))
  end
end

defmodule Karoo.Fetch do
  def track_url(id) do
    "https://dashboard.hammerhead.io/v1/shares/tracking/#{id}"
  end

  def activity(id) do
    case HTTPoison.get(track_url(id)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        # {:ok, body} = Poison.decode(body)
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
