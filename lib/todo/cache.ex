defmodule Todo.Cache do
  use GenServer

  def start_link(_) do
    IO.puts("Starting todo cache...")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(name) do
    GenServer.call(__MODULE__, {:server_process, name})
  end

  @impl GenServer
  def init(_) do
    Todo.Database.start_link()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, name}, _, servers) do
    case Map.fetch(servers, name) do
      {:ok, server} ->
        {:reply, server, servers}

      :error ->
        {:ok, server} = Todo.Server.start(name)
        {:reply, server, Map.put(servers, name, server)}
    end
  end
end
