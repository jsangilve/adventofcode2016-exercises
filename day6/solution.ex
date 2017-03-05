defmodule Day6 do

  @spec group_columns(list, list) :: list
  def group_columns(data, codes) do
    Enum.reduce(data, codes, fn row, acc  ->
      String.graphemes(row)
      |> Enum.zip(acc) # group chars and occurrence maps
      |> Enum.map(fn {char, col} -> Map.update(col, char, 1, &(&1 + 1)) end)
    end)
  end

  @spec repetition_code(list) :: String.t
  def repetition_code(data) do
    code_length = String.length(Enum.at(data, 0))
    codes = List.duplicate(%{}, code_length)
    group_columns(data, codes)
    |> Enum.map(fn col ->
        Enum.sort_by(col, fn {_letter, freq} -> -freq end)
        |> hd
        |> elem(0)
        end)
  end

end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [fname] -> fname
end

data = File.read!(filename) |> String.split("\n", trim: true)

IO.puts "The error corrected version is: #{Day6.repetition_code(data)}"



