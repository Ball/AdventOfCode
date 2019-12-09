defmodule Day02Test do
    use ExUnit.Case, async: true

    test "halt opcode" do
        assert [99] == %IntcodeComputer{memory: [99]}
                        |> IntcodeComputer.execute()
                        |> elem(0)
    end
    test "add opcode" do
        assert [1,9,10,70,99,3,11,0,99,30,40,50] ==
            %IntcodeComputer{memory: [1,9,10,3,99,3,11,0,99,30,40,50]}
            |> IntcodeComputer.execute()
            |> elem(0)
    end
    test "add and multiply" do
        assert [3500,9,10,70,2,3,11,0,99,30,40,50] ==
            %IntcodeComputer{memory: [1,9,10,3,2,3,11,0,99,30,40,50]}
            |> IntcodeComputer.execute()
            |> elem(0)
    end
    test "Load and execute" do
        assert IntcodeComputer.process(12,2) == 5305097
    end
    test "Find specific execution values" do
        init = IntcodeComputer.load()
        options = for noun <- 0..99, verb <- 0..99 do
            {noun,verb, IntcodeComputer.process(init, noun, verb)}
        end
        {noun,verb, _} = Enum.find(options, fn {_,_,v} -> v == 19690720 end)
        assert (100*noun)+verb == 4925
    end
end
