defmodule Day2 do

  @typep position :: { integer, integer }

  def parse(raw_codes) do
    String.split(raw_codes, "\n", trim: true)
    |> Enum.map(fn ln -> String.split(ln, "", trim: true) end)
  end

  @spec coord(position, position) :: position
  defp coord({2, 2}, {_, 1}), do: {2, 1}
  defp coord({2, 2}, _), do: {2, 2}
  defp coord({2, -2}, {_, -1}), do: {2, -1}
  defp coord({2, -2}, _), do: {2, -2}
  defp coord({1, 1}, {x, y}) when x < 1 or y > 1, do: {1, 1}
  defp coord({3, 1}, {x, y}) when x > 3 or y > 1, do: {3, 1}
  defp coord({0, 0}, {x, y}) when x < 0 or y > 0 or y < 0, do: {0, 0}
  defp coord({4, 0}, {x, y}) when x > 4 or y > 0 or y < 0, do: {4, 0}
  defp coord({1, -1}, {x, y}) when x < 1 or y < -1, do: {1, -1}
  defp coord({3, -1}, {x, y}) when x > 3 or y < -1, do: {3, -1}
  defp coord(_, pos), do: pos

  @spec decode(String.t, position) :: position
  defp decode("U", {x, y}) do coord({x, y}, {x, y + 1}) end
  defp decode("D", {x, y}) do coord({x, y}, {x, y - 1}) end
  defp decode("L", {x, y}) do coord({x, y}, {x - 1, y}) end
  defp decode("R", {x, y}) do coord({x, y}, {x + 1, y}) end

  @spec keypad(position) :: integer
  defp keypad({2, 2}), do: "1"
  defp keypad({1, 1}), do: "2"
  defp keypad({2, 1}), do: "3"
  defp keypad({3, 1}), do: "4"
  defp keypad({0, 0}), do: "5"
  defp keypad({1, 0}), do: "6"
  defp keypad({2, 0}), do: "7"
  defp keypad({3, 0}), do: "8"
  defp keypad({4, 0}), do: "9"
  defp keypad({1, -1}), do: "A"
  defp keypad({2, -1}), do: "B"
  defp keypad({3, -1}), do: "C"
  defp keypad({2, -2}), do: "D"

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

IO.puts "Bathrooom code 2: #{File.read!(filename) |> Day2.get_code()}"
