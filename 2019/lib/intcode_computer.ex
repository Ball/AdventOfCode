defmodule IntcodeComputer do
  @enforce_keys [:memory]
  defstruct [:memory, input: [], output: [], instruction_pointer: 0]

  def execute_program(memory, input \\ []) do
    %IntcodeComputer{memory: memory, input: input}
    |> execute()
  end

  def execute(computer) do
    raw_opcode = Enum.at(computer.memory, computer.instruction_pointer)
    opcode = rem(raw_opcode, 100)
    parameters = Integer.digits(div(raw_opcode, 100)) |> Enum.reverse()

    case {opcode, parameters} do
      {99, _} ->
        {computer.memory, computer.output}

      {1, modes} ->
        computer
        |> add(modes)
        |> execute()

      {2, modes} ->
        computer
        |> multiply(modes)
        |> execute()

      {3, _} ->
        computer
        |> store_input()
        |> execute()

      {4, modes} ->
        computer
        |> write_output(modes)
        |> execute()

      {5, modes} ->
        computer
        |> jump_if_true(modes)
        |> execute()

      {6, modes} ->
        computer
        |> jump_if_false(modes)
        |> execute()

      {7, modes} ->
        computer
        |> less_than(modes)
        |> execute()

      {8, modes} ->
        computer
        |> equals(modes)
        |> execute()
    end
  end

  def read(memory, address, 0), do: indirect_read(memory, address)
  def read(memory, address, _), do: direct_read(memory, address)

  def indirect_read(memory, address) do
    Enum.at(memory, Enum.at(memory, address))
  end

  def direct_read(memory, address) do
    Enum.at(memory, address)
  end

  def indirect_write(memory, address, value) do
    List.replace_at(memory, Enum.at(memory, address), value)
  end

  def store_input(computer) do
    %{computer |
      instruction_pointer: computer.instruction_pointer + 2,
      memory: indirect_write(computer.memory, computer.instruction_pointer + 1, hd(computer.input)),
      input: tl(computer.input)
    }
  end

  def modes <- offset, do: modes |> Enum.at(offset, 0)

  def write_output(computer, modes) do
    %{computer |
      instruction_pointer: computer.instruction_pointer + 2,
      output: [read(computer.memory, computer.instruction_pointer + 1, modes <- 0) | computer.output]
    }
  end

  def add(computer, modes) do
    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)
    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: indirect_write(computer.memory, computer.instruction_pointer  + 3, a + b)
    }
  end

  def multiply(computer, modes) do
    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)
    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: indirect_write(computer.memory, computer.instruction_pointer + 3, a * b)
    }
  end

  def less_than(computer, modes) do
    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)

    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: indirect_write(computer.memory, computer.instruction_pointer + 3, if( a < b , do: 1, else: 0))
    }
  end

  def equals(computer, modes) do
    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)
    %{computer|
      instruction_pointer: computer.instruction_pointer + 4,
      memory: indirect_write(computer.memory, computer.instruction_pointer + 3, if(a == b, do: 1, else: 0))
    }
  end

  def jump_if_true(computer, modes) do
    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    destination = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)

    %{computer |
      instruction_pointer: (if (a==0), do: computer.instruction_pointer + 3, else: destination)
    }
  end

  def jump_if_false(computer, modes) do

    a = read(computer.memory, computer.instruction_pointer + 1, modes <- 0)
    destination = read(computer.memory, computer.instruction_pointer + 2, modes <- 1)

    %{computer |
      instruction_pointer: (if (a==0), do: destination, else: computer.instruction_pointer + 3)
    }
  end

  def load(file \\ "day02_input.txt") do
    {:ok, content} = File.read(file)

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> (fn memory -> %IntcodeComputer{memory: memory} end).()
  end

  def process(computer, noun, verb) do
    %{computer |
      memory: computer.memory
        |> List.replace_at(1, noun)
        |> List.replace_at(2, verb)
    }
    |> IntcodeComputer.execute()
    |> elem(0)
    |> Enum.at(0)
  end

  def process(noun, verb) do
    load()
    |> process(noun, verb)
  end
end
