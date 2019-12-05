defmodule Day04 do
    def count_strictly_valid_in_range(lower, upper) do
        lower..upper
        |> Enum.filter(&validate_never_decrease/1)
        |> Enum.filter(&validates_doubles/1)
        |> Enum.count()
    end
    def count_valid_in_range(lower, upper) do
        lower..upper
        |> Enum.filter(&validate_never_decrease/1)
        |> Enum.filter(&validates_multiples/1)
        |> Enum.count()
    end
    def validate_never_decrease(code) do
        code
        |> Integer.digits()
        |> is_never_decreasing()
    end
    def validates_doubles(code) do
        code
        |> Integer.digits()
        |> has_double()
    end
    def validates_multiples(code) do
        code
        |> Integer.digits()
        |> has_multiple()
    end

    def has_double([]), do: false
    def has_double([a | tail]) do
       matches = [a | tail] |> Enum.take_while(fn e -> e == a end)
       if matches |> Enum.count == 2 do
            true
       else
            [a | tail]
            |> Enum.drop_while(fn e -> e == a end)
            |> has_double
       end 
    end

    def has_multiple([]), do: false
    def has_multiple([_]), do: false
    def has_multiple([a | [b | tail]]) do
        if a == b do
            true
        else
            has_multiple([b | tail])
        end
    end
    
    def is_never_decreasing([]), do: true
    def is_never_decreasing([_]), do: true
    def is_never_decreasing([a | [b | tail]]) do
        if (a > b) do
            false
        else
            is_never_decreasing([b|tail])
        end
    end 
end