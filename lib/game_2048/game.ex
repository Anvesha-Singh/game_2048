# lib/game_2048/game.ex
defmodule Game2048.Game do
  @moduledoc """
  Game logic for 2048
  """

  def new_game do
    empty_board()
    |> add_random_tile()
    |> add_random_tile()
  end

  def empty_board do
    List.duplicate(0, 16)
  end

  def add_random_tile(board) do
    empty_positions = Enum.with_index(board)
    |> Enum.filter(fn {val, _idx} -> val == 0 end)
    |> Enum.map(fn {_val, idx} -> idx end)

    case empty_positions do
      [] -> board
      positions ->
        position = Enum.random(positions)
        value = if :rand.uniform() < 0.7, do: 2, else: 4
        List.replace_at(board, position, value)
    end
  end

  def move(board, direction) when direction in [:left, :right, :up, :down] do
    board
    |> transform(direction)
    |> merge()
    |> transform(reverse_direction(direction))
    |> add_random_tile()
  end

  defp transform(board, :left), do: board
  defp transform(board, :right), do: board |> Enum.chunk_every(4) |> Enum.map(&Enum.reverse/1) |> List.flatten()
  defp transform(board, :up), do: transpose(board)
  defp transform(board, :down) do
    board
    |> Enum.chunk_every(4)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
    |> List.flatten()
  end

  defp reverse_direction(:left), do: :left
  defp reverse_direction(:right), do: :right
  defp reverse_direction(:up), do: :down
  defp reverse_direction(:down), do: :up

  defp transpose(board) do
    board
    |> Enum.chunk_every(4)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten()
  end

  defp merge(board) do
    board
    |> Enum.chunk_every(4)
    |> Enum.map(&merge_row/1)
    |> List.flatten()
  end

  defp merge_row(row) do
    row
    |> Enum.reject(&(&1 == 0))
    |> do_merge([])
    |> pad_right()
  end

  defp do_merge([], acc), do: Enum.reverse(acc)
  defp do_merge([x], acc), do: [x | acc] |> Enum.reverse()
  defp do_merge([x, x | rest], acc), do: do_merge(rest, [x * 2 | acc])
  defp do_merge([x, y | rest], acc), do: do_merge([y | rest], [x | acc])

  defp pad_right(row) do
    padding = List.duplicate(0, 4 - length(row))
    row ++ padding
  end
end
