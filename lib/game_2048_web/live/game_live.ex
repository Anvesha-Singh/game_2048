defmodule Game2048Web.GameLive do
  use Game2048Web, :live_view
  alias Game2048.Game

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      board: Game.new_game(),
      score: 0,
      move_direction: nil,
      last_new_tile: nil
    )}
  end

  def handle_event("new_game", _params, socket) do
    {:noreply, assign(socket,
      board: Game.new_game(),
      score: 0,
      move_direction: nil,
      last_new_tile: nil
    )}
  end

  def handle_event("move", %{"key" => key}, socket) do
    direction = case key do
      "ArrowLeft" -> :left
      "ArrowRight" -> :right
      "ArrowUp" -> :up
      "ArrowDown" -> :down
      _ -> nil
    end

    if direction do
      old_board = socket.assigns.board
      new_board = Game.move(old_board, direction)
      new_tile_index = find_new_tile(old_board, new_board)
      new_score = calculate_score(new_board)

      {:noreply, assign(socket,
        board: new_board,
        score: new_score,
        move_direction: direction,
        last_new_tile: new_tile_index
      )}
    else
      {:noreply, socket}
    end
  end

  defp find_new_tile(old_board, new_board) do
    Enum.with_index(Enum.zip(old_board, new_board))
    |> Enum.find_value(fn {{old, new}, index} ->
      if old == 0 && new != 0, do: index
    end)
  end

  defp calculate_score(board) do
    board |> Enum.sum()
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto p-4" phx-window-keydown="move">
      <div class="flex justify-between mb-4">
        <h1 class="text-4xl font-bold">2048</h1>
        <div class="text-2xl">Score: <%= @score %></div>
      </div>

      <button
        class="bg-blue-500 hover:bg-blue-600 transition-colors text-white px-4 py-2 rounded mb-4"
        phx-click="new_game">
        New Game
      </button>

      <div class="grid grid-cols-4 gap-2 bg-gray-200 p-2 rounded relative">
        <%= for {tile, index} <- Enum.with_index(@board) do %>
          <div
            class={[
              "h-20 flex items-center justify-center rounded text-2xl font-bold",
              "transition-all duration-200 transform",
              tile_color(tile),
              move_animation(@move_direction),
              if(@last_new_tile == index, do: "animate-pop-in")
            ]}
          >
            <%= if tile > 0, do: tile %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp tile_color(0), do: "bg-gray-300"
  defp tile_color(2), do: "bg-blue-200 text-gray-800"
  defp tile_color(4), do: "bg-blue-300 text-gray-800"
  defp tile_color(8), do: "bg-blue-400 text-white"
  defp tile_color(16), do: "bg-blue-500 text-white"
  defp tile_color(32), do: "bg-blue-600 text-white"
  defp tile_color(64), do: "bg-blue-700 text-white"
  defp tile_color(128), do: "bg-blue-800 text-white"
  defp tile_color(_), do: "bg-blue-900 text-white"

  defp move_animation(nil), do: ""
  defp move_animation(:left), do: "animate-slide-left"
  defp move_animation(:right), do: "animate-slide-right"
  defp move_animation(:up), do: "animate-slide-up"
  defp move_animation(:down), do: "animate-slide-down"
end
