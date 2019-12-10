defmodule IntcodeComputer do
  @enforce_keys [:memory]
  defstruct [:memory, input: [], output: [], instruction_pointer: 0, relative_base: 0]

  def new(program) do
    %IntcodeComputer{
      memory: :array.from_list(program, 0),
    }
  end
  def execute_program(memory, input \\ []) do
    %{new(memory) |
      input: input
    }
    |> execute()
  end

  def execute(computer) do
    raw_opcode = :array.get(computer.instruction_pointer, computer.memory)
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

      {3, modes} ->
        computer
        |> store_input(modes)
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

      {9, modes} ->
        computer
        |> adjust_relative_base(modes)
        |> execute()
    end
  end

  def read(computer, address, 0), do: indirect_read(computer.memory, address)
  def read(computer, address, 1), do: direct_read(computer.memory, address)
  def read(computer, address, 2), do: relative_read(computer, address)
  def write(computer, address, value, 0), do: indirect_write(computer, address, value)
  def write(computer, address, value, 2), do: relative_write(computer, address, value)

  def indirect_read(memory, address) do
    :array.get(:array.get(address, memory), memory)
  end

  def relative_read(computer, address) do
    :array.get(:array.get(address, computer.memory) + computer.relative_base, computer.memory)
  end

  def direct_read(memory, address) do
    :array.get(address, memory)
  end

  def indirect_write(computer, address, value) do
    :array.set(:array.get(address, computer.memory), value, computer.memory)
  end
  def direct_write(memory, address, value) do
    :array.set(address, value, memory)
  end
  def relative_write(computer, address, value) do
    addr = :array.get(address, computer.memory) + computer.relative_base
    :array.set(addr, value, computer.memory)
  end

  def store_input(computer, modes) do
    memory = write(computer, computer.instruction_pointer + 1, hd(computer.input), modes <- 0)
    %{computer |
      instruction_pointer: computer.instruction_pointer + 2,
      memory: memory,
      input: tl(computer.input)
    }
  end

  def modes <- offset, do: modes |> Enum.at(offset, 0)

  def write_output(computer, modes) do
    %{computer |
      instruction_pointer: computer.instruction_pointer + 2,
      output: [read(computer, computer.instruction_pointer + 1, modes <- 0) | computer.output]
    }
  end

  def add(computer, modes) do
    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer, computer.instruction_pointer + 2, modes <- 1)
    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: write(computer, computer.instruction_pointer  + 3, a + b, modes <- 2)
    }
  end

  def multiply(computer, modes) do
    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer, computer.instruction_pointer + 2, modes <- 1)
    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: write(computer, computer.instruction_pointer + 3, a * b, modes <- 2)
    }
  end

  def less_than(computer, modes) do
    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer, computer.instruction_pointer + 2, modes <- 1)

    memory = write(computer, computer.instruction_pointer + 3, if( a < b, do: 1, else: 0), modes <- 2)

    %{computer |
      instruction_pointer: computer.instruction_pointer + 4,
      memory: memory
    }
  end

  def equals(computer, modes) do
    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    b = read(computer, computer.instruction_pointer + 2, modes <- 1)
    %{computer|
      instruction_pointer: computer.instruction_pointer + 4,
      memory: write(computer, computer.instruction_pointer + 3, if(a == b, do: 1, else: 0), modes <- 2)
    }
  end

  def jump_if_true(computer, modes) do
    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    destination = read(computer, computer.instruction_pointer + 2, modes <- 1)

    %{computer |
      instruction_pointer: (if (a==0), do: computer.instruction_pointer + 3, else: destination)
    }
  end

  def jump_if_false(computer, modes) do

    a = read(computer, computer.instruction_pointer + 1, modes <- 0)
    destination = read(computer, computer.instruction_pointer + 2, modes <- 1)

    %{computer |
      instruction_pointer: (if (a==0), do: destination, else: computer.instruction_pointer + 3)
    }
  end

  def adjust_relative_base(computer, modes) do
    %{computer |
      instruction_pointer: computer.instruction_pointer + 2,
      relative_base: computer.relative_base + read(computer, computer.instruction_pointer + 1, modes <- 0)
    }
  end

  def load(file \\ "day02_input.txt") do
    {:ok, content} = File.read(file)

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> IntcodeComputer.new()
  end

  def process(computer, noun, verb) do
    %{computer |
      memory: computer.memory
        |> (fn a -> :array.set(1, noun, a)end).()
        |> (fn a -> :array.set(2, verb, a)end).()
    }
    |> IntcodeComputer.execute()
    |> elem(0)
    |> (fn a -> :array.get(0, a) end).()
  end

  def process(noun, verb) do
    load()
    |> process(noun, verb)
  end
end
