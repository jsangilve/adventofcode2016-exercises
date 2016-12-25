defmodule Day1 do

  # calculate subject's direction and coordinates
  def calc({"N", x, y}, "R", blocks), do: {"E", x + blocks, y}  
  def calc({"N", x, y}, "L", blocks), do: {"W", x - blocks, y}
  def calc({"S", x, y}, "R", blocks), do: {"W", x - blocks, y}
  def calc({"S", x, y}, "L", blocks), do: {"E", x + blocks, y}
  def calc({"E", x, y}, "R", blocks), do: {"S", x, y - blocks}
  def calc({"E", x, y}, "L", blocks), do: {"N", x, y + blocks}
  def calc({"W", x, y}, "R", blocks), do: {"N", x, y + blocks}
  def calc({"W", x, y}, "L", blocks), do: {"S", x, y - blocks}

  def coordinate(code, acc) do
    { d, blocks} = String.split_at(code, 1)
    calc(acc, d, String.to_integer(blocks)) 
  end

  def distance(list) do
    {face, x, y} = Enum.reduce(list, {"N", 0, 0}, &coordinate/2)
    IO.puts([face, " ", to_string(x), ",", to_string(y)])
    abs(x) + abs(y)
  end

end

inst = ["R4", "R5", "L5", "L5", "L3", "R2", "R1", "R1", "L5", "R5", "R2", "L1", "L3", "L4", "R3", "L1", "L1", "R2", "R3", "R3", "R1", "L3", "L5", "R3", "R1", "L1", "R1", "R2", "L1", "L4", "L5", "R4", "R2", "L192", "R5", "L2", "R53", "R1", "L5", "R73", "R5", "L5", "R186", "L3", "L2", "R1", "R3", "L3", "L3", "R1", "L4", "L2", "R3", "L5", "R4", "R3", "R1", "L1", "R5", "R2", "R1", "R1", "R1", "R3", "R2", "L1", "R5", "R1", "L5", "R2", "L2", "L4", "R3", "L1", "R4", "L5", "R4", "R3", "L5", "L3", "R4", "R2", "L5", "L5", "R2", "R3", "R5", "R4", "R2", "R1", "L1", "L5", "L2", "L3", "L4", "L5", "L4", "L5", "L1", "R3", "R4", "R5", "R3", "L5", "L4", "L3", "L1", "L4", "R2", "R5", "R5", "R4", "L2", "L4", "R3", "R1", "L2", "R5", "L5", "R1", "R1", "L1", "L5", "L5", "L2", "L1", "R5", "R2", "L4", "L1", "R4", "R3", "L3", "R1", "R5", "L1", "L4", "R2", "L3", "R5", "R3", "R1", "L3"]

IO.puts("Distance " <> to_string(Day1.distance(inst)) <> " blocks")
