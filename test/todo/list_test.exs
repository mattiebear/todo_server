defmodule Todo.ListTest do
  use ExUnit.Case

  doctest Todo.List

  test "creates a new list" do
    list = Todo.List.new()

    assert %Todo.List{} = list
  end

  test "creates a list with default entries" do
    item_1 = Todo.Item.new(~D[2024-10-01], "Go swimming")
    item_2 = Todo.Item.new(~D[2024-10-02], "Play golf")
    list = Todo.List.new([item_1, item_2])

    assert Enum.count(list.entries) == 2
  end

  test "adds an entry to the list" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])

    assert Enum.count(list.entries) == 1
  end

  test "fetches a specific entry by id" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])

    entry = Todo.List.get(list, 1)
    assert entry.text == "Go swimming"
  end

  test "updates an entry" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])
    list = Todo.List.update(list, 1, fn entry -> %Todo.Item{entry | text: "Eat cake"} end)

    assert Todo.List.get(list, 1).text == "Eat cake"
  end

  test "does not update a nonexistent entry" do
    list = Todo.List.new() |> Todo.List.update(1, fn entry -> entry end)

    assert %Todo.List{entries: %{}} = list
  end

  test "returns all entries" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])

    assert Todo.List.all(list) |> length() == 1
  end

  test "returns all entries for a specifed date" do
    item_1 = Todo.Item.new(~D[2024-10-01], "Go swimming")
    item_2 = Todo.Item.new(~D[2024-10-02], "Play golf")
    list = Todo.List.new([item_1, item_2])

    entries = Todo.List.fetch(list, ~D[2024-10-01])

    assert hd(entries).text == "Go swimming"
  end

  test "deletes an entry from the list" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])
    list = Todo.List.delete(list, 1)

    assert Todo.List.get(list, 1) == nil
  end

  test "completes an entry" do
    item = Todo.Item.new(~D[2024-10-01], "Go swimming")
    list = Todo.List.new([item])
    list = Todo.List.complete(list, 1)
    entry = Todo.List.get(list, 1)

    assert %Todo.Item{complete: true} = entry
  end
end
