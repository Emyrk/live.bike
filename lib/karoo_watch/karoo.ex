defmodule Karoo do
  use Agent

  # rwUtCs7G
  def start(id) do
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
