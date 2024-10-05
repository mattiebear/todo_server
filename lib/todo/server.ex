defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add(server, item) do
    GenServer.cast(server, {:add, item})
  end

  def fetch(server, date) do
    GenServer.call(server, {:fetch, date})
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_cast({:add, item}, state) do
    new_state = Todo.List.add(state, item)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call({:fetch, date}, _from, state) do
    {:reply, Todo.List.fetch(state, date), state}
  end
end
