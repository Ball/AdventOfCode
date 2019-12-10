defmodule Day10Test do
    use ExUnit.Case
    @map1 """
.#..#
.....
#####
....#
...##
""" |> String.trim()
    @map2 """
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
""" |> String.trim()
    @map3 """
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
"""
    @map4 """
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
""" |> String.trim()
    @map5 """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
""" |> String.trim()

    @map6 """
.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....X...###..
..#.#.....#....##
""" |> String.trim()

    test "largest in small maps" do
        assert 10 == Day10.map_to_coordinates(@map1) |> Enum.count()
        assert {"#", 3, 4, 8} == Day10.map_to_coordinates(@map1) |> Day10.coordinates_to_visible_count() |> Enum.max_by(fn a -> elem(a, 3) end)
        assert {"#", 11, 13, 210} == Day10.preferred_on_map(@map5)
        assert {"#", 6, 3, 41} == Day10.preferred_on_map(@map4)
        assert {"#", 1, 2, 35} == Day10.preferred_on_map(@map3)
        assert {"#", 5, 8, 33} == Day10.preferred_on_map(@map2)
    end

    test "find station on map" do
        assert {"#", 19, 14, 274} == Day10.find_station_on_map()
    end

    test "ordering astroids while spinning" do

        assert (:math.pi() / 2.0) == Day10.to_theta(0,1)
        assert 0 == Day10.to_theta(1,0)
        assert :math.pi() == Day10.to_theta(-1,0)
        assert :math.pi() * 1.25 == Day10.to_theta(-1, -1)
        assert :math.pi() * 1.5 == Day10.to_theta(0,-1)

        assert {0.0, [{"#", 2, 3, 0.0, 5.0}]} == Day10.map_to_coordinates(@map6) |> Day10.with_polar_from({"#", 7, 3}) |> hd()
        assert 30 == Day10.map_to_coordinates(@map6) |> Day10.with_polar_from({"#", 7, 3}) |> Enum.count()
        assert 36 ==  Day10.map_to_coordinates(@map6) |> Day10.with_polar_from({"#", 7, 3}) |> Day10.in_polar_order() |> Enum.count()

        assert 300 == Day10.map_to_coordinates(@map5) |> Enum.count()
        astroids_in_order = Day10.map_to_coordinates(@map5) |> Day10.with_polar_from({"#", 11, 13}) |> Day10.in_polar_order()
        assert {"#", 11, 12, 1.5707963267948966, 1.0} == Enum.at(astroids_in_order, 0)
        assert {"#", 12, 1, 1.6539375586833378, 12.041594578792296} == Enum.at(astroids_in_order, 1)
        assert {"#", 8, 2, 1.3045442776439713, 11.40175425099138} == Enum.at(astroids_in_order, 199)
    end

    test "placing a bet on the 200th astroid to get shot" do
        assert 305 == Day10.bet_for_200th()
    end

end
