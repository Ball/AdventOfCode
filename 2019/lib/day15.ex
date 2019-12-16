# defmodule Day15 do
#     def run_robot() do
#         File.read("day15_input.txt")
#         |> elem(1)
#         |> String.split(",", trim: true)
#         |> Enum.map(&String.trim/1)
#         |> Enum.map(&String.to_integer/1)
#         |> run_program()
#     end
#     def run_program(program) do
#         cpu = %{IntcodeComputer.new(program) |
#             output: self
#         }
#         droid = spawn(fn -> IntcodeComputer.execute(cpu) end)
#         move(droid, {0,0}, [])
#     end
#     def pick_move(position, walls) do
#         cond
#             !
#     end
#     def move(droid, position, walls) do
#         d = pick_move(position, walls)
#         send droid, {:input, d}
#         listen(droid, position, walls)
#     end
# end
