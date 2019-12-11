defmodule Day07 do
  def run_amplification(computer, phases) do
    by_stage(phases, computer, 0)
  end
  def run_feedback_amplification(program, phases) do
    amps = phases
           |> Enum.with_index()
           |> Enum.map(fn {p,i} -> Day07.Amplifier.new(program, i)
                                   |> (fn amp -> spawn (fn -> Day07.Amplifier.run(amp, p) end) end).() end)

    send Enum.at(amps, 0), {:output_pid, Enum.at(amps, 1)}
    send Enum.at(amps, 1), {:output_pid, Enum.at(amps, 2)}
    send Enum.at(amps, 2), {:output_pid, Enum.at(amps, 3)}
    send Enum.at(amps, 3), {:output_pid, Enum.at(amps, 4)}
    send Enum.at(amps, 4), {:output_pid, Enum.at(amps, 0)}
    send Enum.at(amps, 4), {:output_pid, self()}
    send Enum.at(amps, 0), {:signal, 0, "driver"}

    feedback_loop(0)

  end
  def feedback_loop(last) do
    receive do
      {:signal, value, _} ->
        feedback_loop(value)
      :finished ->
        last
    end
  end
  def by_stage([], _, signal), do: signal
  def by_stage([phase | phases], computer, signal) do
    by_stage(phases, computer, amplify(phase, computer, signal))
  end
  def amplify(phase, computer, signal) do
    computer
    |>IntcodeComputer.execute_computer([phase, signal])
    |> elem(0)
    |> hd()
  end
  def all_phases() do
    permutations([0,1,2,3,4])
  end
  def all_feedback_phases() do
    permutations([5,6,7,8,9])
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

  def find_max_feedback_sequence() do
    {:ok, content} = File.read("day07_input.txt")

    program = content
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    all_feedback_phases()
    |> Enum.map(fn phases -> {run_feedback_amplification(program, phases), phases} end)
    |> Enum.max_by(fn {a,_} -> a end)
    |> elem(0)
  end

  defmodule Amplifier do
    defstruct [:name, :computer, :outputs, :cpu_pid]

    def new(program, name) do
      %Amplifier{
        name: name,
        computer: IntcodeComputer.new(program),
        outputs: []
      }
    end

    def run(amplifier, phase) do
      amp = self()
      amplifier = %{amplifier |
        cpu_pid: spawn(fn -> IntcodeComputer.execute(%{amplifier.computer| output: amp}) end)
      }
      send amplifier.cpu_pid, {:input, phase}
      loop(amplifier)
    end

    def loop(amplifier) do
      receive do
        {:output_pid, pid} ->
          loop(%{amplifier| outputs: [pid | amplifier.outputs] })
        {:output, value} ->
          for out <- amplifier.outputs do
            send out, {:signal, value, amplifier.name}
          end
          loop(amplifier)
        {:signal, value, name} ->
          send amplifier.cpu_pid, {:input, value}
          loop(amplifier)
        {:end, _} ->
          for out <- amplifier.outputs do
            send out, :finished
          end
      end
    end

  end
end
