defmodule Day03Test do
  use ExUnit.Case, async: true

  test "s distance" do
    intersections =
      Day03.intersections(
        ["R8", "U5", "L5", "D3"],
        ["U7", "R6", "D4", "L4"]
      )
      |> MapSet.to_list()

    assert intersections == [{3, 3}, {6, 5}]
    assert Day03.closest(intersections) == 6

    assert Day03.intersections(
             ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
             ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
           )
           |> Day03.closest() ==
             159

    assert Day03.intersections(
             ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
             ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
           )
           |> Day03.closest() ==
             135
  end

  test "read diagram for closest" do
    assert Day03.find_closest() == 651
  end

  test "steps to shortest" do
    assert Day03.steps_to_shortest(
             ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
             ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
           ) == 610

    assert Day03.steps_to_shortest(
             ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
             ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
           ) == 410
  end

  test "read diagram for shortest" do
    assert Day03.find_shortest() == 7534
  end
end
