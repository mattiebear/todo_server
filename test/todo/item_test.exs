defmodule Todo.ItemTest do
  use ExUnit.Case

  doctest Todo.Item

  test "creates a new item" do
    item = Todo.Item.new(~D[2024-10-01], "Do something fun")

    assert %Todo.Item{text: "Do something fun", complete: false} = item
  end
end
