defmodule Day2 do

  @typep position :: { integer, integer }

  @spec coordNormal(integer) :: integer
  defp coordNormal(val) when val >= 1, do: 1
  defp coordNormal(val) when val <= -1, do: -1
  defp coordNormal(_), do: 0

  @spec decodeNormal(String.t, position) :: {integer, integer}
  defp decodeNormal("U", {x, y}), do: {x, coordNormal(y + 1)}
  defp decodeNormal("D", {x, y}), do: {x, coordNormal(y - 1)}
  defp decodeNormal("L", {x, y}), do: {coordNormal(x - 1), y}
  defp decodeNormal("R", {x, y}), do: {coordNormal(x + 1), y}

  @spec keypadNormal(position) :: String.t
  defp keypadNormal({-1, 1}), do: "1"
  defp keypadNormal({0, 1}), do: "2"
  defp keypadNormal({1, 1}), do: "3"
  defp keypadNormal({-1, 0}), do: "4"
  defp keypadNormal({0, 0}), do: "5"
  defp keypadNormal({1, 0}), do: "6"
  defp keypadNormal({-1, -1}), do: "7"
  defp keypadNormal({0, -1}), do: "8"
  defp keypadNormal({1, -1}), do: "9"

  @spec coordStar(position, position) :: position
  defp coordStar({2, 2}, {_, 1}), do: {2, 1}
  defp coordStar({2, 2}, _), do: {2, 2}
  defp coordStar({2, -2}, {_, -1}), do: {2, -1}
  defp coordStar({2, -2}, _), do: {2, -2}
  defp coordStar({1, 1}, {x, y}) when x < 1 or y > 1, do: {1, 1}
  defp coordStar({3, 1}, {x, y}) when x > 3 or y > 1, do: {3, 1}
  defp coordStar({0, 0}, {x, y}) when x < 0 or y > 0 or y < 0, do: {0, 0}
  defp coordStar({4, 0}, {x, y}) when x > 4 or y > 0 or y < 0, do: {4, 0}
  defp coordStar({1, -1}, {x, y}) when x < 1 or y < -1, do: {1, -1}
  defp coordStar({3, -1}, {x, y}) when x > 3 or y < -1, do: {3, -1}
  defp coordStar(_, pos), do: pos

  @spec decodeStar(String.t, position) :: position
  defp decodeStar("U", {x, y}) do coordStar({x, y}, {x, y + 1}) end
  defp decodeStar("D", {x, y}) do coordStar({x, y}, {x, y - 1}) end
  defp decodeStar("L", {x, y}) do coordStar({x, y}, {x - 1, y}) end
  defp decodeStar("R", {x, y}) do coordStar({x, y}, {x + 1, y}) end

  @spec keypadStar(position) :: integer
  defp keypadStar({2, 2}), do: "1"
  defp keypadStar({1, 1}), do: "2"
  defp keypadStar({2, 1}), do: "3"
  defp keypadStar({3, 1}), do: "4"
  defp keypadStar({0, 0}), do: "5"
  defp keypadStar({1, 0}), do: "6"
  defp keypadStar({2, 0}), do: "7"
  defp keypadStar({3, 0}), do: "8"
  defp keypadStar({4, 0}), do: "9"
  defp keypadStar({1, -1}), do: "A"
  defp keypadStar({2, -1}), do: "B"
  defp keypadStar({3, -1}), do: "C"
  defp keypadStar({2, -2}), do: "D"

  @spec get_code(String.t, fun, fun) :: String.t
  defp get_code(inst, fn_decode, fn_keypad) do
    {_, result} = Enum.reduce(inst, {{0, 0}, ""}, fn c, {pos, code} -> 
      case c do
        "\n" -> {pos, code <> fn_keypad.(pos)}
        _  -> {fn_decode.(c, pos), code}
      end
    end)
    result
  end

  def decode(inst, type \\ :normal) do
    case type do
      :normal -> get_code(inst, &decodeNormal/2, &keypadNormal/1)
      :star -> get_code(inst, &decodeStar/2, &keypadStar/1)
    end
  end
end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

instructions = File.read!(filename) |> String.split("", trim: true)

IO.puts "Bathrooom code: #{Day2.decode(instructions)}"
IO.puts "Bathrooom code 2: #{Day2.decode(instructions, :star)}"
