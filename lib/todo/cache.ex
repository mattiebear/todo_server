defmodule Todo.Cache do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, name) do
    GenServer.call(cache_pid, {:server_process, name})
  end

  @impl GenServer
  def init(_) do
    Todo.Database.start()
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
