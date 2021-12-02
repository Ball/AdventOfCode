defmodule Day17 do
    def read_screen() do
        File.read("day17_input.txt")
        |> elem(1)
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> with_program()
    end
    def find_alignment_parameters(intersections) do
        intersections
        |> Enum.map(fn {x,y} -> x*y end)
    end
    def find_intersections(screen) do
        height = Enum.count(screen)
        width = Enum.count(hd(screen))
        {height, width}
        for y <- 1 .. height-1,
            x <- 1 .. width-1,
            intersection?({x,y}, screen) do
                {x-1,y-1}
            end
    end
    def intersection?({x,y}, screen) do
        [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
        |> Enum.all?(fn point -> scaffolding?(point, screen) end)
    end

    def scaffolding?({x,y}, screen) do
        screen
        |> Enum.at(y)
        |> Enum.at(x)
        |> (fn c -> c == "#" end).()
    end

    def with_program(program) do
        computer = %{IntcodeComputer.new(program)| output: self() }
        cpu_pid = spawn(fn -> IntcodeComputer.execute(computer) end)
        wait_for_line([[]])
    end
    def wait_for_line([current| old_lines]) do
        receive do
            {:output, ?\n} ->
                [[] | [current | old_lines]]
                |> wait_for_line()

            {:output, c} ->
                [[to_string([c]) | current] | old_lines]
                |> wait_for_line()
            {:end, _} ->
                old_lines
                |> Enum.reject(fn x -> x==[] end)
                |> Enum.map(&(Enum.reverse(&1)))
                |> Enum.reverse()
        end
    end
end
