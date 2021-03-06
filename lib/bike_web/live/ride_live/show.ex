defmodule BikeWeb.RideLive.Show do
  use BikeWeb, :live_view

  alias Bike.Activity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ride, Activity.get_ride!(id))}
  end

  defp page_title(:show), do: "Show Ride"
  defp page_title(:edit), do: "Edit Ride"
end
