defmodule Day07 do
  def run_amplification(computer, phases) do
    by_stage(phases, computer, 0)
  end
  def run_feedback_amplification(program, phases) do
    IntcodeComputer.execute_program(program, [hd(phases) | [0 | tl(phases)]])
    |> elem(1)
  end
  def by_stage([], _, signal), do: signal
  def by_stage([phase | phases], computer, signal) do
    by_stage(phases, computer, amplify(phase, computer, signal))
  end
  def amplify(phase, computer, signal) do
    %{ computer |
      input: [phase, signal]
    }
    |>IntcodeComputer.execute()
    |> elem(1)
    |> hd()
  end
  def all_phases() do
    permutations([0,1,2,3,4])
  end
  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

  def find_max_sequence() do
    computer = IntcodeComputer.load("day07_input.txt")
    all_phases()
    |> Enum.map(fn phases -> {run_amplification(computer, phases), phases} end)
    |> Enum.max_by(fn {a,_} -> a end)
    |> elem(0)
  end
end
