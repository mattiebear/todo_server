defmodule Todo.List do
  @moduledoc """
  A collection of todo items with basic CRUD management
  """

  defstruct entries: %{}, next_id: 1

  def new(entries \\ []) do
    Enum.reduce(entries, %Todo.List{}, fn item, list -> add(list, item) end)
  end

  def add(list, item) do
    item = Map.put(item, :id, list.next_id)
    entries = Map.put(list.entries, item.id, item)

    %Todo.List{list | entries: entries, next_id: list.next_id + 1}
  end

  def get(list, id) do
    Map.get(list.entries, id)
  end

  def all(list) do
    Map.values(list.entries)
  end

  def fetch(list, date) do
    all(list)
    |> Enum.filter(fn entry -> entry.date == date end)
  end

  def update(list, id, updater) do
    case Map.fetch(list.entries, id) do
      :error ->
        list

      {:ok, old_entry} ->
        new_entry = updater.(old_entry)
        new_entries = Map.put(list.entries, new_entry.id, new_entry)
        %Todo.List{list | entries: new_entries}
    end
  end

  def delete(list, id) do
    Map.update!(list, :entries, fn entries ->
      Map.delete(entries, id)
    end)
  end

  def complete(list, id) do
    Map.update!(list, :entries, fn entries ->
      Map.update!(entries, id, fn entry ->
        Map.put(entry, :complete, true)
      end)
    end)
  end
end
