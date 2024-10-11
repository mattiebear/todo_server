defmodule Todo.Server do
  use GenServer, restart: :temporary

  @idle_timeout :timer.seconds(10)

  def start_link(name) do
    IO.puts("Starting server for #{name}...")
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def add(server, item) do
    GenServer.cast(server, {:add, item})
  end

  def fetch(server, date) do
    GenServer.call(server, {:fetch, date})
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  @impl GenServer
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}, @idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add, item}, {name, list}) do
    new_list = Todo.List.add(list, item)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @idle_timeout}
  end

  @impl GenServer
  def handle_call({:fetch, date}, _from, {name, list}) do
    {:reply, Todo.List.fetch(list, date), {name, list}, @idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {name, list}) do
    IO.puts("Stopping server for #{name}...")
    {:stop, :normal, {name, list}}
  end
end
