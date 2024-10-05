defmodule Todo.Item do
  @moduledoc """
  A single item in a todo list
  """
  alias __MODULE__

  defstruct [:date, :text, complete: false, id: nil]

  @spec new(date :: Calendar.date(), text :: String.t()) :: %Item{}

  @doc """
  Creates a new todo item

  ## Examples

      iex> Todo.Item.new(~D[2024-10-01], "Go nuts")
      %Todo.Item{id: nil, date: ~D[2024-10-01], text: "Go nuts", complete: false}

  """

  def new(date, text) do
    %Item{date: date, text: text}
  end
end
