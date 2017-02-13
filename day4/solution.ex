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

  @docp """
  Decode checksum from room_name.
  """
  @spec decode_checksum(String.t) :: list
  defp decode_checksum(name) do
    name |> String.replace("-", "")
    |> String.graphemes
    # Reduce into character occurrence %{a => N, b => M,...}
    |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
    # Then group by occurrence
    |> Enum.group_by(fn {_, n} -> n end, fn {char, _} -> char end)
    |> Enum.reverse()
    |> build_checksum("")
  end


  @spec decode_room(list) :: map
  defp decode_room(room) do
    [name, sector, checksum ] = String.split(room, ~r{[0-9]+}, [include_captures: true, trim: true])
    #    sector_id = String.to_integer(sector)
    clean_name = String.replace(name, "-", " ", trim: true)
    %{
    #      name: clean_name |> String.graphemes |> decipher(sector_id),
      name: clean_name,
      decoded_checksum: decode_checksum(name),
      #      sector: sector_id,
      sector: String.to_integer(sector),
      checksum: checksum,
    }
  end

  @spec valid_room?(String.t, String.t) :: boolean
  defp valid_room?(decoded, chksum), do: decoded == String.slice(chksum, 1, 5)

  def rooms(data) do
    Enum.map(data, &decode_room/1)
    |> Enum.filter(fn %{decoded_checksum: decoded, checksum: checksum} ->
        valid_room?(decoded, checksum)
    end)
  end

  defp decipher(l, shifts, acc \\ "")
  defp decipher([letter | letters], shifts, acc) do
    word = acc <> shift_cipher(letter, shifts)
    decipher(letters, shifts, word)
  end
  defp decipher([], _, word), do: word

  defp shift_cipher(" ", _), do: " "
  defp shift_cipher(letter, shifts) do
    <<index, _>> = letter <> <<0>>
    letter_index = ?a..?z |> Enum.find_index(&(&1 == index))
    << ?a..?z |> Enum.at(rem(letter_index + shifts, 26))>>
  end

  @spec sum_sectors(list) :: list
  def sum_sectors(data) do
    rooms(data)
    |> Enum.reduce(0, fn(%{sector: sector}, acc) ->
     acc + sector
    end)
  end

  @doc """

  """
  @spec north_pole_sector(list) :: integer
  def north_pole_sector(data) do
    room = rooms(data)
    |> Enum.find(fn %{name: name, sector: sector} -> 
         name 
         |> String.graphemes
         |> decipher(sector)
         |> String.starts_with?("north") 
    end)
    room[:sector]
  end
end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

data = File.read!(filename) |> String.split("\n", trim: true)
IO.puts "Sector ID sum: #{Day4.sum_sectors(data)}"
#IO.inspect Day4.north_pole(data), limit: 10000
IO.puts "North Pole Sector Id: #{Day4.north_pole_sector(data)}"
