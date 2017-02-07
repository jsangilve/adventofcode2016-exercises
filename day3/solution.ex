defmodule Day3 do
  
  @spec filter_by_row(list) :: list
  defp filter_by_row(data) do
    Enum.filter(data, fn triangle -> 
        split_row(triangle)
        |> Enum.map(&String.to_integer/1)
        |> is_triangle?
      end
    )
  end

  defp split_row(triangle) when is_binary(triangle), do: String.split(triangle, " ", trim: true) 
  defp split_row(triangle), do: triangle

  @spec sort_by_col(list) :: list
  defp sort_by_col([r1, r2, r3 | rest]) do
    [a1, b1, c1 ] = String.split(r1, " ", trim: true)
    [a2, b2, c2 ] = String.split(r2, " ", trim: true)
    [a3, b3, c3 ] = String.split(r3, " ", trim: true)
    [[a1, a2, a3], [b1, b2, b3], [c1, c2, c3]] ++ sort_by_col(rest)
  end
  defp sort_by_col([]), do: []

  @spec is_triangle?(list) :: boolean
  defp is_triangle?([a, b, c]) do
     a + b > c and a + c > b and b + c > a
  end 

  @spec count_triangles(list) :: integer
  def count_triangles(data) do
    filter_by_row(data) |> length
  end

  
  @spec count_col_triangles(list) :: integer
  def count_col_triangles(data) do
    sort_by_col(data)
    |> filter_by_row
    |> length
  end

end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

data = File.read!(filename) |> String.split("\n", trim: true)
IO.puts "Triangles: #{Day3.count_triangles(data)}"
IO.puts "Vertical Triangles: #{Day3.count_col_triangles(data)}"
