defmodule Day2 do

  @typep position :: { integer, integer }

  @spec coord(integer) :: integer
  defp coord(val) when val >= 1, do: 1
  defp coord(val) when val <= -1, do: -1
  defp coord(_), do: 0

  @spec decode(String.t, position) :: {integer, integer}
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
  def get_code(inst) do
    {_, result} = Enum.reduce(inst, {{0, 0}, ""}, fn c, {pos, code} -> 
      case c do
        "\n" -> {pos, code <> keypad(pos)}
        _  -> {decode(c, pos), code}
      end
    end)
    result
  end
end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

instructions = File.read!(filename) |> String.split("", trim: true)
IO.puts "Bathrooom code: #{Day2.get_code(instructions)}"
