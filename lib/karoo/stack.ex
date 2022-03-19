defmodule Stack do
  use GenServer

  # Callbacks
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  # init(init_arg)
  #   Invoked when started. Start_link/3 or start/3 will block until returns.
  #   Synchronous

  # code_change(old_vsn, state, extra)
  #   Supports hot swapping, crazy

  # format_status(reason, pdict_and_state)
  #   Return a formated status of the GenServer?

  # handle_call(request, from, state)
  #   Synchronous calls

  # handle_cast(request, state)
  #   Async messages

  # handle_continue(continue, state)
  #   Continue instructions?

  # handle_info(msg, state)
  #   Handle all other messages

  # terminate(reason, state)
  #   About to exit, please cleanup
end
