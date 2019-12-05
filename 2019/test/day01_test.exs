defmodule Day01Test do
  use ExUnit.Case, async: true

  test "Basic Computation" do
    assert Day01.fuel_for(12) == 2
    assert Day01.fuel_for(14) == 2
    assert Day01.fuel_for(1969) == 654
    assert Day01.fuel_for(100_756) == 33583
  end

  test "Advanced Computation" do
    assert Day01.total_fuel_for(14) == 2
    assert Day01.total_fuel_for(1969) == 966
    assert Day01.total_fuel_for(100_756) == 50346
  end

  test "Total Computation" do
    assert Day01.calculate() == 3_336_985
  end

  test "Total Advanced Computation" do
    assert Day01.advanced_calculate() == 5_002_611
  end
end
