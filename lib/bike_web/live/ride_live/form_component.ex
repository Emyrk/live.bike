defmodule BikeWeb.RideLive.FormComponent do
  use BikeWeb, :live_component

  alias Bike.Activity

  @impl true
  def update(%{ride: ride} = assigns, socket) do
    changeset = Activity.change_ride(ride)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"ride" => ride_params}, socket) do
    changeset =
      socket.assigns.ride
      |> Activity.change_ride(ride_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"ride" => ride_params}, socket) do
    save_ride(socket, socket.assigns.action, ride_params)
  end

  defp save_ride(socket, :edit, ride_params) do
    case Activity.update_ride(socket.assigns.ride, ride_params) do
      {:ok, _ride} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ride updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_ride(socket, :new, ride_params) do
    case Activity.create_ride(ride_params) do
      {:ok, _ride} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ride created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
