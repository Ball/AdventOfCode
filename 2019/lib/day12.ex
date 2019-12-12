defmodule Moon do
  defstruct [:position, :velocity]

  def new(position) do
    %Moon{position: position, velocity: {0, 0, 0}}
  end
end

defmodule Day12 do

  def how_long_until_matching(moons) do
    moons
    |> step_velocity()
    |> step_position()
    |> how_long_until_matching(moons, 1)
  end
  def how_long_until_matching(moons, starting, n) do
    if moons == starting do
        n
    else
        moons
        |> step_velocity()
        |> step_position()
        |> how_long_until_matching(starting, n+1)
    end
  end
  def starter_system() do
    [
      Moon.new({9, 13, -8}),
      Moon.new({-3, 16, -17}),
      Moon.new({-4, 11, -10}),
      Moon.new({0, -2, -2})
    ]
  end

  def delta_for(n1, n2) do
    cond do
      n1 == n2 -> 0
      n1 < n2 -> 1
      true -> -1
    end
  end

  def simulate(moons, 0), do: moons

  def simulate(moons, n) do
    moons
    |> step_velocity()
    |> step_position()
    |> simulate(n - 1)
  end

  def step_velocity(moons) do
    moons
    |> Enum.map(fn moon -> velocity_from_others(moon, moons |> Enum.reject(&(&1 == moon))) end)
  end

  def step_position(moons) do
    moons
    |> Enum.map(&move/1)
  end

  def system_energy(moons) do
    moons
    |> Enum.map(&energy_for/1)
    |> Enum.sum()
  end

  def energy_for(moon) do
    potential_energy_for(moon) * kinetic_energy_for(moon)
  end

  def potential_energy_for(%Moon{position: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end

  def kinetic_energy_for(%Moon{velocity: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end

  def move(moon) do
    {x1, y1, z1} = moon.position
    {x2, y2, z2} = moon.velocity
    %{moon | position: {x1 + x2, y1 + y2, z1 + z2}}
  end

  def velocity_from_others(moon1, moons) do
    moons
    |> Enum.map(fn other -> velocity_from_other(moon1, other) end)
    |> Enum.concat([moon1.velocity])
    |> Enum.reduce(fn {x1, y1, z1}, {x2, y2, z2} -> {x1 + x2, y1 + y2, z1 + z2} end)
    |> (fn v -> %{moon1 | velocity: v} end).()
  end

  def velocity_from_other(%Moon{position: {x1, y1, z1}}, %Moon{position: {x2, y2, z2}}) do
    {delta_for(x1, x2), delta_for(y1, y2), delta_for(z1, z2)}
  end
end
