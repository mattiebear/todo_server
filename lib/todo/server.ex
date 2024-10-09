defmodule Todo.Server do
  use GenServer, restart: :temporary

  def start_link(db_name) do
    IO.puts("Starting server for #{db_name}...")
    GenServer.start_link(__MODULE__, db_name, name: via_tuple(db_name))
  end

  def add(server, item) do
    GenServer.cast(server, {:add, item})
  end

  def fetch(server, date) do
    GenServer.call(server, {:fetch, date})
  end

  defp via_tuple(db_name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, db_name})
  end

  @impl GenServer
  def init(db_name) do
    {:ok, {db_name, Todo.Database.get(db_name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_cast({:add, item}, {name, list}) do
    new_list = Todo.List.add(list, item)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:fetch, date}, _from, {name, list}) do
    {:reply, Todo.List.fetch(list, date), {name, list}}
  end
end
