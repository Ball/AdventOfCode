defmodule Day16 do

    def read_file() do
        File.read("day16_input.txt")
        |> elem(1)
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
    end

    def process(numbers) do
        input = Stream.cycle(numbers) |> Enum.take(1_000 * Enum.count(numbers))
        offset = numbers |> Enum.take(7) |> Integer.undigits()

        to_skip = rem(offset, Enum.count(numbers))
        # IO.puts("offset #{offset} % #{Enum.count(numbers)}  ->  #{to_skip}")

        # IO.puts("process #{to_skip}")

        # eight = (numbers ++ numbers) |> Enum.drop(to_skip - 1) |> Enum.take(8)

        # IO.puts("eight #{inspect(eight)}")

        output = input |> Day16.phases(100)  #|> Integer.digits()
        output |> Enum.drop(offset) |> Enum.take(8) |> Integer.undigits()
        # output |> Integer.undigits
    end

    def phases(digits, 0), do: digits #|> Enum.take(8) |> Integer.undigits()
    def phases(digits, phase) do

        (1 .. Enum.count(digits))
        |> Enum.map(fn i -> stage(digits, i) end)
        |> phases(phase - 1)
    end
    def stage(digits, i) do
        [0,1,0,-1]
        |> expand_by(i)
        |> Stream.drop(1)
        |> Stream.take(Enum.count(digits))
        |> Enum.zip(digits)
        |> Enum.map(fn {a,b} -> a * b end)
        |> Enum.sum()
        |> abs()
        |> rem(10)
    end

    def expand_by(pattern, i) do
        pattern
        |> Enum.map(fn e -> (1..i) |> Enum.map(fn _ -> e end) end)
        |> Stream.concat()
        |> Stream.cycle()
    end
end
