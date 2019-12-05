defmodule Day02 do
    def execute(memory, input \\ []) do
        execute(0, memory, input, [])
    end
    def execute(address, memory, input, output) do
        raw_opcode = Enum.at(memory, address)
        opcode = rem(raw_opcode, 100)
        parameters = Integer.digits(div(raw_opcode, 100)) |> Enum.reverse()
        case {opcode, parameters} do
            {99, _} ->
                {memory, output}
            {1, modes} ->
                execute(address+4, add(address, memory, modes), input, output)
            {2, modes} ->
                execute(address+4, multiply(address, memory, modes), input, output)
            {3, _} ->
                execute(address+2, store_input(address, memory, hd(input)), tl(input), output)
            {4, modes} ->
                execute(address+2, memory, input, write_output(address, memory, output, modes))
            {5, modes} ->
                execute(jump_if_true(address, memory, modes), memory, input, output)
            {6, modes} ->
                execute(jump_if_false(address, memory, modes), memory, input, output)
            {7, modes} ->
                execute(address+4, less_than(address, memory, modes), input, output)
            {8, modes} ->
                execute(address+4, equals(address, memory, modes), input, output)

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
    def write_output(address, memory, output, modes) do
        case Enum.at(modes, 0, 0) do
            0 -> [indirect_read(memory, address + 1) | output ]
            _ -> [direct_read(memory, address + 1) | output]
        end
    end
    def add(address, memory, modes) do
        a = read(memory, address + 1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        indirect_write(memory, address + 3, a + b)
    end
    def multiply(address, memory, modes) do
        a = read(memory, address + 1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        indirect_write(memory, address + 3, a * b)
    end
    def less_than(address, memory, modes) do
        a = read(memory, address + 1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        indirect_write(memory, address+3, if( a < b, do: 1, else: 0))
    end
    def equals(address, memory, modes) do
        a = read(memory, address + 1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        indirect_write(memory, address+3, if( a == b, do: 1, else: 0))
    end
    def jump_if_true(address, memory, modes) do
        a = read(memory, address + 1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        if a == 0 do
            address + 3
        else
            b
        end
    end
    def jump_if_false(address, memory, modes) do
        a = read(memory, address+1, Enum.at(modes, 0, 0))
        b = read(memory, address + 2, Enum.at(modes, 1, 0))
        if a == 0 do
            b
        else
            address + 3
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
        |> List.replace_at(1,noun)
        |> List.replace_at(2,verb)
        |> Day02.execute()
        |> elem(0)
        |> Enum.at(0)
    end
    def process(noun, verb) do
        load()
        |> process(noun,verb)
    end
end