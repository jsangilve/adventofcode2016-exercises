defmodule Day2 do

  @typep position :: { integer, integer }

  def parse(raw_codes) do
    String.split(raw_codes, "\n", trim: true)
    |> Enum.map(fn ln -> String.split(ln, "", trim: true) end)
  end
  
  @spec coord(integer) :: integer
  defp coord(val) when val >= 1, do: 1
  defp coord(val) when val <= -1, do: -1
  defp coord(_), do: 0

  @spec decode(String.t, position) :: position
  defp decode("U", {x, y}), do: {x, coord(y + 1)}
  defp decode("D", {x, y}), do: {x, coord(y - 1)}
  defp decode("L", {x, y}), do: {coord(x - 1), y}
  defp decode("R", {x, y}), do: {coord(x + 1), y}

  @spec keypad(position) :: String.t
  defp keypad({-1, 1}), do: "1"
  defp keypad({0, 1}), do: "2"
  defp keypad({1, 1}), do: "3"
  defp keypad({-1, 0}), do: "4"
  defp keypad({0, 0}), do: "5"
  defp keypad({1, 0}), do: "6"
  defp keypad({-1, -1}), do: "7"
  defp keypad({0, -1}), do: "8"
  defp keypad({1, -1}), do: "9"

  @spec get_code(String.t) :: String.t
  def get_code(codes) do
    {positions, _} = parse(codes) |> Enum.map_reduce({0,0}, fn ln, acc -> 
      current = Enum.reduce(ln, acc, &decode/2) 
      {current, current} 
    end)
    Enum.reduce(positions, "", fn p, acc -> acc <> keypad(p) end)
  end

end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

IO.puts "Bathrooom code: #{File.read!(filename) |> Day2.get_code()}"
