defmodule Bike.Karoo.GarbageCollection do
  use GenServer
  use Timex
  require Logger
  import Ecto.Query, only: [from: 2]

  @second 1000
  @minute @second * 60
  @hour @minute * 60
  @day @hour * 24

  def start_link(interval, stale \\ @day * 3) do
    Logger.info(
      "Garbage collection started with " <>
        "intervals=#{human_dur(duration_ms(interval))}, " <>
        "stale=#{human_dur(duration_ms(stale))}"
    )

    {:ok, pid} = GenServer.start_link(__MODULE__, %{interval: interval, stale: stale})
    GenServer.cast(pid, :start)
    {:ok, pid}
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def handle_cast(:start, state) do
    Process.send(self(), :poll_activity, [])
    {:noreply, state}
  end

  @impl true
  def handle_info(:poll_activity, state) do
    garbageCollect(state)
    schedule_work(state.interval)
    {:noreply, state}
  end

  defp garbageCollect(state) do
    %{interval: _interval, stale: stale} = state
    {:ok, now} = DateTime.now("Etc/UTC")
    before = DateTime.add(now, -1 * stale, :millisecond)

    queryable = from(e in "entries", where: e.updated_at < ^before)

    {:ok, %{delete_all: {deleted, _}}} =
      Ecto.Multi.new()
      |> Ecto.Multi.delete_all(:delete_all, queryable)
      |> Bike.Repo.transaction()

    if deleted > 0 do
      Logger.info("Deleted #{deleted} records")
    end
  end

  defp schedule_work(interval) do
    Process.send_after(self(), :poll_activity, interval)
  end

  defp human_dur(dur) do
    Timex.Format.Duration.Formatters.Humanized.format(dur)
  end

  defp duration_ms(d) do
    Timex.Duration.from_milliseconds(d)
  end
end
