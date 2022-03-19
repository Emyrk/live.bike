defmodule Bike.Karoo.TestRider do
  use ExUnit.Case
  alias Bike.Karoo

  setup %{} do
    id = "rwUtCs7G"
    {:ok, rider} = Karoo.Rider.start_link(id)
    %{rider: rider}
  end

  test "fetch activity", %{rider: rider} do
    assert Karoo.Rider.id(rider) != ""
    assert match?({:ok, _}, assert(Karoo.Rider.activity(rider)))
  end
end
