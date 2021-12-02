defmodule Day17Test do
   use ExUnit.Case, async: true

  @tag skip: "Not yet"
    test "scan for intersections" do
        # Not 6457
        # Not 6611
        # 7665 is too high
        assert 6611 == Day17.read_screen()
                     |> Day17.find_intersections()
                     |> Day17.find_alignment_parameters()
                     |> Enum.sum()

    end

end
