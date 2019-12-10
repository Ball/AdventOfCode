defmodule Day09Test do
    use ExUnit.Case, async: true

    test "Quine" do
      quine = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
      output = IntcodeComputer.new(quine)
                        |> IntcodeComputer.execute_computer()
      assert quine == output |> elem(0) |> Enum.reverse()
    end
    test "Large numbers" do
      out = IntcodeComputer.new([1102,34915192,34915192,7,4,7,99,0])
                   |> IntcodeComputer.execute_computer()
                   |> elem(0)
                   |> hd

      assert 16 == out |> Integer.digits() |> Enum.count
    end
    test "output in middle" do
      assert 1125899906842624 == IntcodeComputer.new( [104,1125899906842624,99])
                                  |> IntcodeComputer.execute_computer()
                                  |> elem(0)
                                  |> hd()
    end
    test "BOOST test mode" do
      assert 3241900951 == IntcodeComputer.load("day09_input.txt")
                            |> IntcodeComputer.execute_computer([1])
                            |> elem(0)
                            |> hd()
    end
    test "BOOST Signals" do
      assert 83089 == IntcodeComputer.load("day09_input.txt")
                            |> IntcodeComputer.execute_computer([2])
                            |> elem(0)
                            |> hd()
    end
end
