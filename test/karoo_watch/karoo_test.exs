defmodule Karoo.TestRider do
  use ExUnit.Case

  setup %{} do
    id = "rwUtCs7G"
    {:ok, rider} = Karoo.start(id)
    %{rider: rider}
  end

  test "fetch activity", %{rider: rider} do
    assert Karoo.id(rider) != ""
    assert match?({:ok, _}, assert(Karoo.activity(rider)))
  end
end
