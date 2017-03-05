defmodule Day6 do

  @spec group_columns(list, list) :: list
  def group_columns(data, columns) do
    Enum.reduce(data, columns, fn row, acc  ->
      String.graphemes(row)
      |> Enum.zip(acc) # group chars and occurrence maps
      |> Enum.map(fn {char, col} -> Map.update(col, char, 1, &(&1 + 1)) end)
    end)
  end

  @spec get_message(list, fun) :: String.t
  defp get_message(data, sort_fun) do
    code_length = String.length(Enum.at(data, 0))
    # generate a list of empty maps (one for each column)
    columns = List.duplicate(%{}, code_length)
    group_columns(data, columns)
    |> Enum.map(fn col ->
        Enum.sort_by(col, sort_fun)
        |> hd
        |> elem(0)
        end)
  end

  @doc """
  Retrieve message using the most common character for each column
  """
  def repetition_code(data), do: get_message(data, fn {_, freq} -> -freq end)

  @doc """
  Retrieve message using the least common character for each column
  """
  def mod_repetition_code(data), do: get_message(data, fn {_, freq} -> freq end)
end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [fname] -> fname
end

data = File.read!(filename) |> String.split("\n", trim: true)

IO.puts "The error corrected version is: #{Day6.repetition_code(data)}"
IO.puts "The modified repetion code is #{Day6.mod_repetition_code(data)}"
