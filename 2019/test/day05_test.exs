defmodule Day05Test do
  use ExUnit.Case

  test "Read and Write to IO" do
    assert ["hello"] ==
      [3, 0, 4, 0, 99]
        |> IntcodeComputer.execute_program(["hello"])
        |> elem(0)


  end

  test "run immediate code" do
    {output, memory} = [1002, 4, 3, 4, 33]
                        |> IntcodeComputer.execute_program()
    assert output == []
    assert memory |> :array.to_list() == [1002, 4, 3, 4, 99]
  end

  test "Test Equal" do
    assert [1] == IntcodeComputer.execute_program([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [8]) |> elem(0)
    assert [0] == IntcodeComputer.execute_program([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [7]) |> elem(0)
    assert [1] == IntcodeComputer.execute_program([3, 3, 1108, -1, 8, 3, 4, 3, 99], [8]) |> elem(0)
    assert [0] == IntcodeComputer.execute_program([3, 3, 1108, -1, 8, 3, 4, 3, 99], [7]) |> elem(0)
  end

  test "Test Less Than" do
    assert [1] == IntcodeComputer.execute_program([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [5]) |> elem(0)
    assert [0] == IntcodeComputer.execute_program([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], [8]) |> elem(0)
    assert [1] == IntcodeComputer.execute_program([3, 3, 1107, -1, 8, 3, 4, 3, 99], [5]) |> elem(0)
    assert [0] == IntcodeComputer.execute_program([3, 3, 1107, -1, 8, 3, 4, 3, 99], [8]) |> elem(0)
  end

  test "jumps" do
    assert [1] ==
             IntcodeComputer.execute_program([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [1])
             |> elem(0)

    assert [0] ==
             IntcodeComputer.execute_program([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], [0])
             |> elem(0)
  end

  test "larger jumps" do
    prog = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,
            1006,20,31,1106,0,36,98,0,0,1002,21,125,
            20,4,20,1105,1,46,104,999,1105,1,46,1101,
            1000,1,20,4,20,1105,1,46,98,99]

    assert [999] == IntcodeComputer.execute_program(prog, [5]) |> elem(0)
    assert [1000] == IntcodeComputer.execute_program(prog, [8]) |> elem(0)
    assert [1001] == IntcodeComputer.execute_program(prog, [9]) |> elem(0)
  end

  test "run thermal environment diagnostic" do
    output =
      IntcodeComputer.load("day05_input.txt")
      |> IntcodeComputer.execute_computer([1])
      |> elem(0)

    assert output == [5_074_395, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end

  test "run thermal radiator diagnostic" do
    output =
      IntcodeComputer.load("day05_input.txt")
      |> IntcodeComputer.execute_computer([5])
      |> elem(0)

    assert output == [8_346_937]
  end
end
