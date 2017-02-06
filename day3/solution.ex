defmodule Day3 do
  
  @spec filter_input(list) :: list
  def filter_input(data) do
    Enum.filter(data, fn triangle -> 
        String.split(triangle, " ", trim: true) 
        |> Enum.map(&String.to_integer/1)
        |> is_triangle?
      end
    )
  end

  @spec is_triangle?(list) :: boolean
  defp is_triangle?([a, b, c]) do
     a + b > c and a + c > b and b + c > a
  end 

  @spec count_triangles(list) :: integer
  def count_triangles(data) do
    length filter_input(data)
  end

end

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end

data = File.read!(filename) |> String.split("\n", trim: true)
IO.puts "Triangles: #{Day3.count_triangles(data)}"
