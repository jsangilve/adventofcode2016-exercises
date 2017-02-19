defmodule Day5 do

  @x_char 120

  @docp """
  Generate hexadecimal representation of md5 hash
  """
  @spec gen_hash(String.t) :: String.t
  defp gen_hash(word), do: :crypto.hash(:md5, word) |> Base.encode16


  @docp """
  Generate next character from door_id and index
  """
  @spec next_character(String.t, String.t, integer) :: {String.t, integer}
  defp next_character("00000" <> xs, _,  index), do: {String.first(xs), String.at(xs, 1), index}
  defp next_character(_, door_id, index) do
    gen_hash(door_id <> to_string(index))
    |> next_character(door_id, index + 1)
  end

  @doc """
  Calculate door's password from left to right
  """
  @spec left_right_pwd(String.t) :: String.t
  @spec left_right_pwd(String.t, integer, String.t, integer) :: String.t

  def left_right_pwd(door_id, index \\ 0, acc \\ "", len \\ 0)
  def left_right_pwd(door_id, index, acc, pwd_length) when pwd_length < 8 do
    {char, _, nindex} = next_character("", door_id, index)
    pwd = acc <> char
    left_right_pwd(door_id, nindex, pwd, String.length(pwd))
  end
  def left_right_pwd(_, _, acc, _), do: acc


  @docp """
  Insert character into 8 digit password
  """
  defp insert_char(acc, pos, char) when pos < 8 do
    unless Enum.at(acc, pos) != @x_char do
      List.replace_at(acc, pos, char)
    else
      acc
    end
  end
  defp insert_char(acc, _, _), do: acc

  @doc """
  Calculate door's password using movie's 'hacking'
  """
  @spec movie_pwd(String.t, integer, list) :: list
  def movie_pwd(door_id, index \\ 0, acc \\ 'xxxxxxxx')
  def movie_pwd(door_id, index, acc) when is_list(acc) do
    {position, char, nindex} = next_character("", door_id, index)
    new_pwd = insert_char(acc, String.to_integer(position, 16), char)
    pwd = if @x_char in new_pwd, do: new_pwd, else: to_string(new_pwd)
    movie_pwd(door_id, nindex, pwd)
  end

  @spec movie_pwd(String.t, integer, String.t) :: String.t
  def movie_pwd(_, _, acc), do: acc

end

#IO.puts "Door's left to right password is: #{ Day5.left_right_pwd("cxdnnyjw")}"
IO.inspect "Door's movie password is: #{ Day5.movie_pwd("cxdnnyjw")}"
