defmodule Day01 do
    def fuel_for(mass) do
        trunc(mass / 3) - 2
    end

    def total_fuel_for(mass) do
        total_fuel_for(mass, 0)
    end
    def total_fuel_for(mass, carry_fuel) do
        fuel = fuel_for(mass)
        if fuel > 0 do
           total_fuel_for(fuel, fuel + carry_fuel) 
        else
            carry_fuel
        end
    end

    def calculate() do
        {:ok, content} = File.read("day01_input.txt")
        content
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(&fuel_for/1)
        |> Enum.sum
    end
    def advanced_calculate() do
        {:ok, content} = File.read("day01_input.txt")
        content
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(&total_fuel_for/1)
        |> Enum.sum
    end
end