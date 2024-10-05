defmodule Todo.ServerTest do
  use ExUnit.Case

  test "adds an item to a server" do
    {:ok, server} = Todo.Server.start()

    Todo.Server.add(server, Todo.Item.new(~D[2024-10-05], "Eat cake"))

    entries = Todo.Server.fetch(server, ~D[2024-10-05])

    assert [%Todo.Item{text: "Eat cake"}] = entries
  end
end
