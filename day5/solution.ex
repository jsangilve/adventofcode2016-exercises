defmodule Day5 do
  
  @docp """
  Generate hexadecimal representation of md5 hash
  """
  @spec gen_hash(String.t) :: String.t
  defp gen_hash(word), do: :crypto.hash(:md5, word) |> Base.encode16


  @docp """
  Generate next character from door_id and index
  """
  @spec next_character(String.t, String.t, integer) :: {String.t, integer}
  defp next_character("00000" <> xs, _,  index), do: {String.first(xs), index}
  defp next_character(_, door_id, index) do
    gen_hash(door_id <> to_string(index))
    |> next_character(door_id, index + 1)
  end

  @spec calc_password(String.t) :: String.t
  @spec calc_password(String.t, integer, String.t, integer) :: String.t
  def calc_password(door_id, index \\ 0, acc \\ "", pwd_length \\ 0)
  def calc_password(door_id, index, acc, pwd_length) when pwd_length < 8 do
    {char, nindex} = next_character("", door_id, index)
    pwd = acc <> char
    calc_password(door_id, nindex, pwd, String.length(pwd))
  end
  def calc_password(_, _, acc, _), do: acc

end

IO.puts "Door's password is: #{ Day5.calc_password("cxdnnyjw")}"
