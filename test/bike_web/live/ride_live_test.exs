defmodule BikeWeb.RideLiveTest do
  use BikeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bike.ActivityFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_ride(_) do
    ride = ride_fixture()
    %{ride: ride}
  end

  describe "Index" do
    setup [:create_ride]

    test "lists all rides", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.ride_index_path(conn, :index))

      assert html =~ "Listing Rides"
    end

    test "saves new ride", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.ride_index_path(conn, :index))

      assert index_live |> element("a", "New Ride") |> render_click() =~
               "New Ride"

      assert_patch(index_live, Routes.ride_index_path(conn, :new))

      assert index_live
             |> form("#ride-form", ride: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ride-form", ride: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ride_index_path(conn, :index))

      assert html =~ "Ride created successfully"
    end

    test "updates ride in listing", %{conn: conn, ride: ride} do
      {:ok, index_live, _html} = live(conn, Routes.ride_index_path(conn, :index))

      assert index_live |> element("#ride-#{ride.id} a", "Edit") |> render_click() =~
               "Edit Ride"

      assert_patch(index_live, Routes.ride_index_path(conn, :edit, ride))

      assert index_live
             |> form("#ride-form", ride: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ride-form", ride: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ride_index_path(conn, :index))

      assert html =~ "Ride updated successfully"
    end

    test "deletes ride in listing", %{conn: conn, ride: ride} do
      {:ok, index_live, _html} = live(conn, Routes.ride_index_path(conn, :index))

      assert index_live |> element("#ride-#{ride.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ride-#{ride.id}")
    end
  end

  describe "Show" do
    setup [:create_ride]

    test "displays ride", %{conn: conn, ride: ride} do
      {:ok, _show_live, html} = live(conn, Routes.ride_show_path(conn, :show, ride))

      assert html =~ "Show Ride"
    end

    test "updates ride within modal", %{conn: conn, ride: ride} do
      {:ok, show_live, _html} = live(conn, Routes.ride_show_path(conn, :show, ride))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ride"

      assert_patch(show_live, Routes.ride_show_path(conn, :edit, ride))

      assert show_live
             |> form("#ride-form", ride: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ride-form", ride: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ride_show_path(conn, :show, ride))

      assert html =~ "Ride updated successfully"
    end
  end
end
