defmodule Day13 do
    def count_blocks() do

        File.read("day13_input.txt")
        |> elem(1)
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> Day13.ScreenDriver.with_program()
        |> elem(0)
        |> Map.to_list()
        |> Enum.filter(fn {_, color} -> color == 2 end)
        |> Enum.count()
    end
    def play_whole_game() do

        File.read("day13_input.txt")
        |> elem(1)
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> (fn program -> program |> List.replace_at(0, 2) end).()
        |> Day13.ScreenDriver.with_program()
        |> elem(1)

    end

    defmodule ScreenDriver do
        defstruct [:computer, :cpu_pid, :parent, :pixels, :paddle, :ball, score: 0]

        def with_program(program) do
            driver = %ScreenDriver {
                computer: IntcodeComputer.new(program),
                parent: self(),
                pixels: %{}
            }

            spawn(fn -> run(driver) end)
            receive do
                {:pixels, pixels, :score, score} ->
                    {pixels, score}
            end
        end
        def run(driver) do
            drvr = self()
            cpu_pid = spawn(fn -> IntcodeComputer.execute(%{driver.computer | output: drvr}) end)
            wait_for_x(%{driver | cpu_pid: cpu_pid})
        end
        def wait_for_x(driver) do
            receive do
                {:output, x} ->
                    driver
                    |> wait_for_y(x)
                {:end, _} ->
                    report(driver)
            end
        end
        def wait_for_y(driver,x) do
            receive do
                {:output, y} ->
                    if {-1,0} == {x,y} do
                        driver
                        |> wait_for_score(x,y)
                    else
                        driver
                        |> wait_for_block(x,y)
                    end
                {:end, _} ->
                    report(driver)
            end
        end
        def wait_for_score(driver, _, _) do
            receive do
                {:output, score} ->
                    %ScreenDriver{ driver| score: score}
                    |> wait_for_x()
                {:end, _} ->
                        report(driver)
            end
        end
        def wait_for_block(driver, x, y) do
            receive do
                {:output, 3} ->
                    %ScreenDriver{ driver|
                        pixels: Map.put(driver.pixels, {x,y}, 3),
                        paddle: {x,y}
                    }
                    |> (fn d ->
                        d end).()
                    |> wait_for_x()

                {:output, 4} ->
                    %ScreenDriver{ driver |
                        pixels: Map.put(driver.pixels, {x,y}, 4),
                        ball: {x,y}
                    }
                    |> (fn d ->
                        d end).()
                    |> move()
                    |> wait_for_x()
                {:output, tile_id} ->
                    %ScreenDriver{driver |
                        pixels: Map.put(driver.pixels, {x,y}, tile_id)
                    }
                    |> wait_for_x()
                {:end, _}
                    -> report(driver)
            end
        end
        def move(driver) do
            cond do
                is_right(driver.ball,driver.paddle) ->
                    move_left(driver)
                is_left(driver.ball, driver.paddle) ->
                    move_right(driver)
                is_under(driver.ball, driver.paddle) ->
                    stay(driver)
            end
            driver
        end
        def is_under({x1,_}, {x2,_}), do: x1 == x2
        def is_under(_, nil), do: true
        def is_left({x1,_}, {x2,_}), do: x1 > x2
        def is_left(_, nil), do: false
        def is_right({x1,_}, {x2,_}), do: x1 < x2
        def is_right(_, nil), do: false
        def move_left(%ScreenDriver{cpu_pid: pid}), do: send pid, {:input, -1}
        def move_right(%ScreenDriver{cpu_pid: pid}), do: send pid, {:input, 1}
        def stay(%ScreenDriver{cpu_pid: pid}), do: send pid, {:input, 0}
        def report(driver) do
            send(driver.parent, {:pixels, driver.pixels, :score, driver.score})
        end
    end
end
