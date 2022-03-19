defmodule BikeWeb.HelloController do
  use BikeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"messenger" => messenger}) do
    conn
    #  How to disable or change layout
    |> put_root_layout(false)
    |> assign(:messenger, messenger)
    |> render("show.html")

    # render(conn, "show.html", messenger: messenger)
  end
end
