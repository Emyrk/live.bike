defmodule BikeWeb.RideLive.Index do
  use BikeWeb, :live_view

  alias Bike.Activity
  alias Bike.Activity.Ride

  # https://elixirforum.com/t/liveview-with-mapboxgl-js/32659
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :rides, [])}
  end

  @impl true
  def handle_event("init_map", _params, socket) do
    # Enum.each(list_current_ride(), fn x ->
    #   push_event(socket, "new_entry", %{entry: x})
    # end)

    #  TODO: Push new events like this, find another way to bootstrap the map.
    {:noreply, push_event(socket, "new_entry", %{entry: hd(list_current_ride())})}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Ride")
  #   |> assign(:ride, Activity.get_ride!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Ride")
  #   |> assign(:ride, %Ride{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Rides")
  #   |> assign(:ride, nil)
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   ride = Activity.get_ride!(id)
  #   {:ok, _} = Activity.delete_ride(ride)

  #   {:noreply, assign(socket, :rides, list_rides())}
  # end

  defp list_current_ride do
    Bike.Karoo.Ride.list()

    # Activity.list_rides()
  end
end
