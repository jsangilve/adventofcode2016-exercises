defmodule Day4 do

  @spec build_checksum(list, String.t) :: String.t
  defp build_checksum([{_, chars} | rest], acc) do
    partial = List.to_string(chars) |> String.slice(0, 5 - String.length(acc))
    if String.length(acc <> partial) >= 5 do
      build_checksum([], acc <> partial)
    else
      build_checksum(rest, acc <> partial)
    end
  end
  defp build_checksum([], acc), do: acc

  @spec decode_room(list) :: list
  defp decode_room(room) do
    [name, sector, chksum ] = String.split(room, ~r{[0-9]+}, [include_captures: true, trim: true])
    decoded = name |> String.replace("-", "")
    |> String.split("", trim: true)
    # Reduce into character occurrence %{a => N, b => M,...} 
    |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
    # Then group by occurrence
    |> Enum.group_by(fn {_, n} -> n end, fn {char, _} -> char end)
    |> Enum.reverse()
    |> build_checksum("")
    [decoded, sector, chksum]
  end

  @spec valid_room?(String.t, String.t) :: boolean
  defp valid_room?(decoded, chksum), do: decoded == String.slice(chksum, 1, 5)


  def rooms(data) do
    Enum.map(data, &decode_room/1)
    |> Enum.filter(fn [room, _, chksum] -> valid_room?(room, chksum) end)
  end

  @spec sum_sectors(list) :: list
  def sum_sectors(data) do
    rooms(data)
    |> Enum.reduce(0, fn([_, sector, _], acc) -> 
     acc + String.to_integer(sector) 
    end)
  end
end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

data = File.read!(filename) |> String.split("\n", trim: true)
IO.puts "Sector ID sum #{Day4.sum_sectors(data)}"
