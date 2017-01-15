defmodule Day2 do

  @typep position :: { integer, integer }

  def parse(raw_codes) do
    String.split(raw_codes, "\n", trim: true)
    |> Enum.map(fn ln -> String.split(ln, "", trim: true) end)
  end

  defp coord(value) do
    cond do
      value >= 1 -> 
        1
      value <= -1 -> 
        -1
      value == 0 -> 
        0
    end
  end

  @spec decode(String.t, position) :: position
  defp decode("U", {x, y}), do: {x, coord(y + 1) }
  defp decode("D", {x, y}), do: {x, coord(y - 1) }
  defp decode("L", {x, y}), do: {coord(x - 1), y}
  defp decode("R", {x, y}), do: {coord(x + 1), y}

  @spec keypad(position) :: integer
  defp keypad({-1, 1}) do 1 end
  defp keypad({0, 1}) do 2 end
  defp keypad({1, 1}) do 3 end
  defp keypad({-1, 0}) do 4 end
  defp keypad({0, 0}) do 5 end
  defp keypad({1, 0}) do 6 end
  defp keypad({-1, -1}) do 7 end
  defp keypad({0, -1}) do 8 end
  defp keypad({1, -1}) do 9 end

  @spec get_code(String.t) :: String.t
  def get_code(codes) do
    parse(codes)
    |> Enum.map(fn ln -> Enum.reduce(ln, {0, 0}, &decode/2) end)
    |> Enum.map(&keypad/1)
    |> Enum.join
  end

end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

IO.puts "Bathrooom code: #{File.read!(filename) |> Day2.get_code()}"
