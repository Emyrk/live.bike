defmodule BikeWeb.PageController do
  use BikeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
