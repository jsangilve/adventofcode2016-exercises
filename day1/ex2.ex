defmodule Day1 do

  def gen_coords(d, x, y, xblocks, yblocks) do
    for i <- 0..xblocks, j <- 0..yblocks, do: {d, x+i, y+j}
  end

  # calculate subject's direction and coordinates
  def calc({:N, x, y}, "R", blocks), do: gen_coords(:E, x, y, blocks, 0) 
  def calc({:N, x, y}, "L", blocks), do: gen_coords(:W, x, y, -blocks, 0)
  def calc({:S, x, y}, "R", blocks), do: gen_coords(:W, x, y, -blocks, 0)
  def calc({:S, x, y}, "L", blocks), do: gen_coords(:E, x, y, blocks, 0)
  def calc({:E, x, y}, "R", blocks), do: gen_coords(:S, x, y, 0, -blocks)
  def calc({:E, x, y}, "L", blocks), do: gen_coords(:N, x, y, 0, blocks)
  def calc({:W, x, y}, "R", blocks), do: gen_coords(:N, x, y, 0, blocks)
  def calc({:W, x, y}, "L", blocks), do: gen_coords(:S, x, y, 0, -blocks)

  def locations(list) do
    Enum.reduce(list, [{:N, 0, 0}], fn code, acc -> 
      { d, blocks} = String.split_at(code, 1)
      last = List.last(acc)
      [_ | tail] = calc(last, d, String.to_integer(blocks))
      acc ++ tail
    end) 
  end

  def repeated(list) do
    locations(list)
    |> Enum.reduce_while([], fn({_, x, y}, acc) ->
      if Enum.member?(acc, {x, y}), do: {:halt, {x, y}}, else: {:cont,[{x, y} | acc]}
    end)
  end

  def distance(x, y) do
    abs(x) + abs(y)
  end

end

inst = ["R4", "R5", "L5", "L5", "L3", "R2", "R1", "R1", "L5", "R5", "R2", "L1", "L3", "L4", "R3", "L1", "L1", "R2", "R3", "R3", "R1", "L3", "L5", "R3", "R1", "L1", "R1", "R2", "L1", "L4", "L5", "R4", "R2", "L192", "R5", "L2", "R53", "R1", "L5", "R73", "R5", "L5", "R186", "L3", "L2", "R1", "R3", "L3", "L3", "R1", "L4", "L2", "R3", "L5", "R4", "R3", "R1", "L1", "R5", "R2", "R1", "R1", "R1", "R3", "R2", "L1", "R5", "R1", "L5", "R2", "L2", "L4", "R3", "L1", "R4", "L5", "R4", "R3", "L5", "L3", "R4", "R2", "L5", "L5", "R2", "R3", "R5", "R4", "R2", "R1", "L1", "L5", "L2", "L3", "L4", "L5", "L4", "L5", "L1", "R3", "R4", "R5", "R3", "L5", "L4", "L3", "L1", "L4", "R2", "R5", "R5", "R4", "L2", "L4", "R3", "R1", "L2", "R5", "L5", "R1", "R1", "L1", "L5", "L5", "L2", "L1", "R5", "R2", "L4", "L1", "R4", "R3", "L3", "R1", "R5", "L1", "L4", "R2", "L3", "R5", "R3", "R1", "L3"]

{x, y} = Day1.repeated(inst)
IO.puts("Distance: #{Day1.distance(x, y)} blocks")
