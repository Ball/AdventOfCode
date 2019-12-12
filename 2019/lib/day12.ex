defmodule Moon do
  defstruct [:position, :velocity]

  def new(position) do
    %Moon{position: position, velocity: {0, 0, 0}}
  end
end

defmodule Day12 do


    def view_into(moons, coord) do
        moons
        |> Enum.map(fn m -> [m.position |> elem(coord), m.velocity |> elem(coord)] end)
    end
    def period_for(moons, coord) do
        starting = moons |> view_into(coord)
        moons
        |> step_velocity()
        |> step_position()
        |> period_for(starting, coord, 1)
    end
    def period_for(moons, starting, coord, n) do
        if view_into(moons, coord) == starting do
            n
        else
            moons
            |> step_velocity()
            |> step_position()
            |> period_for(starting, coord, n+1)
        end
    end
  def how_long_until_matching(moons) do
    [0,1,2]
    |> Enum.map(&(period_for(moons, &1)))
    |> Enum.reduce(&(lcm(&1, &2)))
  end

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div((a*b),Integer.gcd(a,b))

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
