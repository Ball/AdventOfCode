defmodule Day11Test do
  use ExUnit.Case, async: true

  test "count the painted panels" do
    assert 1894 == Day11.painted_pannels()
                  |> Enum.map(fn {_,{x,y}} -> {x,y} end)
                  |> Enum.uniq()
                  |> Enum.count()
  end
  test "drawing the registraion" do
    assert Day11.insignia() == """
...##.#..#.####.#....####...##.###..#..#...
....#.#.#.....#.#.......#....#.#..#.#..#...
....#.##.....#..#......#.....#.###..####...
....#.#.#...#...#.....#......#.#..#.#..#...
.#..#.#.#..#....#....#....#..#.#..#.#..#...
..##..#..#.####.####.####..##..###..#..#...
""" |> String.trim()

  end
end
