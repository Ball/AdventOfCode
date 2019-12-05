defmodule Day03 do
    def find_closest() do
        {:ok, content} = File.read("day03_input.txt")
        [one,two] = content
                     |> String.split("\n", trim: true)
                     |> Enum.map(fn line -> String.split(line, ",", trim: true) end)
        intersections(one, two)
        |> closest
    end
    def find_shortest() do
        {:ok, content} = File.read("day03_input.txt")
        [one,two] = content
                     |> String.split("\n", trim: true)
                     |> Enum.map(fn line -> String.split(line, ",", trim: true) end)
        steps_to_shortest(one, two)
    end
    def intersections(wire1, wire2) do
        path1 = trace(wire1) |> Enum.reverse()
        path2 = trace(wire2) |> Enum.reverse()
        MapSet.intersection(MapSet.new(path1), MapSet.new(path2))
        |> MapSet.delete({0,0})
    end
    def closest(intersections) do
        intersections
        |> Enum.map(fn {x,y} -> abs(x) + abs(y) end)
        |> Enum.min
    end
    def distance({x1, y1}, {x2, y2}) do
        abs(x1 - x2) + abs(y1 - y2)
    end
    def steps_to_shortest(wire1, wire2) do
        intersections(wire1, wire2)
        |> Enum.map(fn cross ->
            travel1 = wire1 |> trace() |> Enum.reverse()
                            |> Enum.take_while(fn e -> e != cross end)
                            |> Enum.reduce({0, {0,0}}, fn p2, {d, p1} -> {d + distance(p1, p2), p2} end)
                            |> elem(0)
            travel2 = wire2 |> trace() |> Enum.reverse()
                            |> Enum.take_while(fn e -> e != cross end)
                            |> Enum.reduce({0, {0,0}}, fn p2, {d, p1} -> {d + distance(p1, p2), p2} end)
                            |> elem(0)
            travel1 + travel2 + 2
        end)
        |> Enum.min()
    end
    def trace(wire) do
        trace([], {0,0}, wire)
    end
    def trace(path, _location, []) do
        path
    end
    def trace(path, {x,y}, [run | wire]) do
        case run do
            "R" <> length ->
                l = String.to_integer(length)
                0..l
                |> Enum.map(fn offset -> {x+offset, y} end)
                |> Enum.reduce(path, fn x, acc -> [x | acc] end)
                |> trace({x+l, y}, wire)
            "L" <> length ->
                l = -String.to_integer(length)
                0..l
                |> Enum.map(fn offset -> {x+offset, y} end)
                |> Enum.reduce(path, fn x, acc -> [x | acc] end)
                |> trace({x+l, y}, wire)
            "D" <> length ->
                l = -String.to_integer(length)
                0..l
                |> Enum.map(fn offset -> {x, y+offset} end)
                |> Enum.reduce(path, fn x, acc -> [x | acc] end)
                |> trace({x, y+l}, wire)
            "U" <> length ->
                l = String.to_integer(length)
                0..l
                |> Enum.map(fn offset -> {x, y+offset} end)
                |> Enum.reduce(path, fn x, acc -> [x | acc] end)
                |> trace({x, y+l}, wire)
        end
    end
end