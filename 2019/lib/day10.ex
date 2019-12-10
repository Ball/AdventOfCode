defmodule Day10 do
    def find_station_on_map() do
        {:ok, content} = File.read("day10_input.txt")

        content
        |> String.trim()
        |> preferred_on_map()
    end
    def bet_for_200th() do
        {:ok, content} = File.read("day10_input.txt")

        content
        |> String.trim()
        |> map_to_coordinates()
        |> with_polar_from({"#", 19, 14})
        |> in_polar_order()
        |> Enum.at(199)
        |> (fn {_,x,y,_,_} -> x * 100 + y end).()
    end
    def preferred_on_map(map_string) do
        map_string
        |> map_to_coordinates()
        |> coordinates_to_visible_count()
        |> Enum.max_by(fn {_,_,_,v} -> v end)
    end
    def map_to_coordinates(map_string) do
        map_string
        |> String.split("\n", trim: true)
        |> Enum.map(&String.codepoints/1)
        |> Enum.map(&Enum.with_index/1)
        |> Enum.with_index()
        |> Enum.map(&row_to_coords/1)
        |> Enum.concat()
        |> Enum.filter(fn {c,_,_} -> c == "#" end)
    end
    def row_to_coords(row) do
        y = elem(row, 1)
        elem(row, 0)
        |> Enum.map(fn {c,x} -> {c,x,y} end)
    end
    def coordinates_to_visible_count(coordinates) do
        coordinates
        |> Enum.map(fn astroid -> Tuple.append(astroid, count_visible_from(astroid, coordinates)) end)
    end
    def with_polar_from(coordinates, {_,x1,y1}) do
        coordinates
        |> Enum.filter(fn {_,x2,y2} -> x1 != x2 || y1 != y2 end)
        |> Enum.map(fn {c, x2, y2} -> {c, x2, y2, to_theta(x1-x2, y1-y2), :math.sqrt(:math.pow(x2-x1, 2) + :math.pow(y2-y1, 2))} end)
        |> Enum.sort_by(fn a -> elem(a,3) end)
        |> Enum.chunk_by(&(elem(&1, 3)))
        |> Enum.map(fn [a | as] -> {elem(a,3), [a | as]} end)
        |> Enum.map(fn {theta, as} -> {theta, Enum.sort_by(as, fn a -> elem(a, 4) end)} end)
    end
    def in_polar_order(coordinates) do
        {front,back} = coordinates |> Enum.split_while(fn {t,_} -> t < :math.pi() / 2.0 end)
        next_from(back++front, [])
    end
    def next_from([], found), do: found |> Enum.reverse()
    def next_from([{t,[a | as]} | coords], found) do
        if as == [] do
            next_from(coords, [a| found])
        else
            next_from(coords ++ [{t,as}], [a| found])
        end
    end
    def count_visible_from(astroid, coordinates) do
        {_,x1,y1} = astroid
        coordinates
        |> Enum.filter(fn a -> a != astroid end)
        |> Enum.map(fn {_,x2,y2} -> to_theta(x1-x2, y1-y2) end)
        |> Enum.uniq()
        |> Enum.count()
    end
    def to_theta(x,y) do
       theta = :math.atan2(y,x)
       if theta < 0, do: theta + 2 * :math.pi(), else: theta
    end

end
