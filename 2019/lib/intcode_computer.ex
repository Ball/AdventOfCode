defmodule IntcodeComputer do
  def execute(memory, input \\ []) do
    execute(0, memory, input, [])
  end

  def execute(instruction_pointer, memory, input, output) do
    raw_opcode = Enum.at(memory, instruction_pointer)
    opcode = rem(raw_opcode, 100)
    parameters = Integer.digits(div(raw_opcode, 100)) |> Enum.reverse()

    case {opcode, parameters} do
      {99, _} ->
        {memory, output}

      {1, modes} ->
        execute(instruction_pointer + 4, add(instruction_pointer, memory, modes), input, output)

      {2, modes} ->
        execute(instruction_pointer + 4, multiply(instruction_pointer, memory, modes), input, output)

      {3, _} ->
        execute(instruction_pointer + 2, store_input(instruction_pointer, memory, hd(input)), tl(input), output)

      {4, modes} ->
        execute(instruction_pointer + 2, memory, input, write_output(instruction_pointer, memory, output, modes))

      {5, modes} ->
        execute(jump_if_true(instruction_pointer, memory, modes), memory, input, output)

      {6, modes} ->
        execute(jump_if_false(instruction_pointer, memory, modes), memory, input, output)

      {7, modes} ->
        execute(instruction_pointer + 4, less_than(instruction_pointer, memory, modes), input, output)

      {8, modes} ->
        execute(instruction_pointer + 4, equals(instruction_pointer, memory, modes), input, output)
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

  def store_input(address, memory, input) do
    indirect_write(memory, address + 1, input)
  end

  def modes <- offset, do: modes |> Enum.at(offset, 0)

  def write_output(instruction_pointer, memory, output, modes) do
    [read(memory, instruction_pointer + 1, modes <- 0) | output]
  end

  def add(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    b = read(memory, instruction_pointer + 2, modes <- 1)
    indirect_write(memory, instruction_pointer + 3, a + b)
  end

  def multiply(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    b = read(memory, instruction_pointer + 2, modes <- 1)
    indirect_write(memory, instruction_pointer + 3, a * b)
  end

  def less_than(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    b = read(memory, instruction_pointer + 2, modes <- 1)
    indirect_write(memory, instruction_pointer + 3, if(a < b, do: 1, else: 0))
  end

  def equals(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    b = read(memory, instruction_pointer + 2, modes <- 1)
    indirect_write(memory, instruction_pointer + 3, if(a == b, do: 1, else: 0))
  end

  def jump_if_true(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    destination = read(memory, instruction_pointer + 2, modes <- 1)

    if a == 0 do
      instruction_pointer + 3
    else
      destination
    end
  end

  def jump_if_false(instruction_pointer, memory, modes) do
    a = read(memory, instruction_pointer + 1, modes <- 0)
    destination = read(memory, instruction_pointer + 2, modes <- 1)

    if a == 0 do
      destination
    else
      instruction_pointer + 3
    end
  end

  def load(file \\ "day02_input.txt") do
    {:ok, content} = File.read(file)

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def process(memory, noun, verb) do
    memory
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> IntcodeComputer.execute()
    |> elem(0)
    |> Enum.at(0)
  end

  def process(noun, verb) do
    load()
    |> process(noun, verb)
  end
end
