defmodule Day12Test do
  use ExUnit.Case, async: true
  # <x=-1, y=0, z=2>
  # <x=2, y=-10, z=-7>
  # <x=4, y=-8, z=8>
  # <x=3, y=5, z=-1>
  test "single body problem" do
    moon1 = Moon.new({-1, 0, 2})
    moon2 = Moon.new({2, -10, -7})
    moon3 = Moon.new({4, -8, 8})
    moon4 = Moon.new({3, 5, -1})

    assert {1, -1, -1} == Day12.velocity_from_other(moon1, moon2)

    assert %Moon{position: {-1, 0, 2}, velocity: {3, -1, -1}} ==
             Day12.velocity_from_others(moon1, [moon2, moon3, moon4])

    assert %Moon{position: {2, -1, 1}, velocity: {3, -1, -1}} ==
             Day12.move(moon1 |> Day12.velocity_from_others([moon2, moon3, moon4]))
  end

  test "moons together" do
    step1 =
      [Moon.new({-1, 0, 2}), Moon.new({2, -10, -7}), Moon.new({4, -8, 8}), Moon.new({3, 5, -1})]
      |> Day12.step_velocity()
      |> Day12.step_position()

    assert Enum.at(step1, 0) == %Moon{position: {2, -1, 1}, velocity: {3, -1, -1}}
    assert Enum.at(step1, 1) == %Moon{position: {3, -7, -4}, velocity: {1, 3, 3}}
    assert Enum.at(step1, 2) == %Moon{position: {1, -7, 5}, velocity: {-3, 1, -3}}
    assert Enum.at(step1, 3) == %Moon{position: {2, 2, 0}, velocity: {-1, -3, 1}}

    assert 179 ==
             [
               Moon.new({-1, 0, 2}),
               Moon.new({2, -10, -7}),
               Moon.new({4, -8, 8}),
               Moon.new({3, 5, -1})
             ]
             |> Day12.simulate(10)
             |> Day12.system_energy()

    assert 1940 ==
             [
               Moon.new({-8, -10, 0}),
               Moon.new({5, 5, 10}),
               Moon.new({2, -7, 3}),
               Moon.new({9, -8, -3})
             ]
             |> Day12.simulate(100)
             |> Day12.system_energy()

    assert 7758 == Day12.starter_system() |> Day12.simulate(1000) |> Day12.system_energy()
  end

  test "repeating history" do
    system1 = [
      Moon.new({-1, 0, 2}),
      Moon.new({2, -10, -7}),
      Moon.new({4, -8, 8}),
      Moon.new({3, 5, -1})
    ]

    system2 = [
      Moon.new({-8, -10, 0}),
      Moon.new({5, 5, 10}),
      Moon.new({2, -7, 3}),
      Moon.new({9, -8, -3})
    ]

    assert 18 == Day12.period_for(system1, 0)
    assert 28 == Day12.period_for(system1, 1)
    assert 44 == Day12.period_for(system1, 2)

    assert 2028 == Day12.period_for(system2, 0)
    assert 5898 == Day12.period_for(system2, 1)
    assert 4702 == Day12.period_for(system2, 2)

    [2028, 5898, 4702]
    assert 1_993_524 == Day12.lcm(2028, 5898)
    assert 4_686_774_924 == Day12.lcm(4702, 1_993_524)

    assert 2772 ==
             system1
             |> Day12.how_long_until_matching()

    assert 4_686_774_924 ==
             system2
             |> Day12.how_long_until_matching()

    assert 354_540_398_381_256 = Day12.starter_system() |> Day12.how_long_until_matching()
  end
end
