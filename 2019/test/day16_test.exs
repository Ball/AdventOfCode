defmodule Day16Test do
  use ExUnit.Case, async: true

  #  @tag skip: "Too long"
  test "phases" do
    # assert 48_226_158 == Day16.phases(Integer.digits(12_345_678), 1) |> Integer.undigits()
    # assert 34_040_438 == Day16.phases(Integer.digits(12_345_678), 2) |> Integer.undigits()
    # assert 03_415_518 == Day16.phases(Integer.digits(12_345_678), 3) |> Integer.undigits()
    # assert 01_029_498 == Day16.phases(Integer.digits(12_345_678), 4) |> Integer.undigits()

    # assert 24_176_176 ==
    #          Day16.phases(
    #            Integer.digits(80_871_224_585_914_546_619_083_218_645_595),
    #            100
    #            ) |> Enum.take(8) |> Integer.undigits()

    # assert 73_745_418 ==
    #          Day16.phases(
    #            Integer.digits(19_617_804_207_202_209_144_916_044_189_917),
    #            100
    #            ) |> Enum.take(8) |> Integer.undigits()

    # assert 52_432_133 ==
    #          Day16.phases(
    #            Integer.digits(69_317_163_492_948_606_335_995_924_319_873),
    #            100
    #          ) |> Enum.take(8) |> Integer.undigits()

    assert 10_332_447 ==
             Day16.read_file()
             |> Day16.phases(100)
             |> Enum.take(8)
             |> Integer.undigits()
  end

  @tag skip: "Need to better handle expansion of the 10-10 pattern"
  test "cycle the output" do
    assert 7 == rem(147, 10)

    # basis = Day16.read_file()
    # to_skip = basis |> Enum.take(7) |> Integer.undigits()

    # assert 5977709 == Stream.cycle(basis) |> Enum.drop(to_skip) |> Enum.take(8) |> Day16.phases(100)

    assert 84_462_026 ==
             Integer.digits(03_036_732_577_212_944_063_491_565_474_664)
             |> Day16.process()

    # assert 78_725_270 ==
    #          Integer.digits(02_935_109_699_940_807_407_585_447_034_323) |> Day16.process()
  end
end
