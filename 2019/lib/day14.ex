defmodule Day14 do
  def read_recipies() do
    File.read("day14_input.txt")
    |> elem(1)
    |> read_recipies()
  end

  def read_recipies(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&read_recipie/1)
    |> Enum.reduce(%{}, fn {a, b}, acc -> Map.put(acc, a, b) end)
  end

  def read_recipie(line) do
    [input, output] = line |> String.split(" => ", trim: true)
    {chem, qty} = read_chemical(output)
    ingredients = input |> String.split(", ", trim: true) |> Enum.map(&read_chemical/1)
    {chem, {chem, qty, ingredients}}
  end

  def read_chemical(string) do
    [ammount, formula] = string |> String.split(" ", trim: true)
    {formula, String.to_integer(ammount)}
  end

  def cost_of(recipies, to_make), do: cost_of(recipies, to_make, 0, %{})

  def cost_of(_, [], ores, _) do
    ores
  end

  def cost_of(recipies, [{"ORE", ammount} | to_make], ores, leftovers) do
    cost_of(recipies, to_make, ores + ammount, leftovers)
  end

  def cost_of(recipies, [{chemical, ammount} | to_make], ores, leftovers) do
    {_, qty, ingredients} = recipies[chemical]

    {still_needed, still_leftovers} = pick_from_leftovers(chemical, ammount, leftovers)

    batches = number_of_batches(qty, still_needed)

    leftover_amomunt = qty * batches - still_needed

    new_to_make =
      ingredients
      |> Enum.map(fn {ingredient, needed} -> {ingredient, needed * batches} end)

    added_leftovers =
      still_leftovers
      |> Map.get_and_update(chemical, fn i -> {i, i + leftover_amomunt} end)
      |> elem(1)

    cost_of(recipies, new_to_make ++ to_make, ores, added_leftovers)
  end

  def pick_from_leftovers(chemical, ammount, leftovers) do
    cond do
        ! Map.has_key?(leftovers, chemical) ->
            {ammount, leftovers |> Map.put(chemical, 0)}
        leftovers[chemical] < ammount ->
            {ammount - leftovers[chemical], leftovers|> Map.put(chemical, 0)}
        true ->
            {0, leftovers |> Map.get_and_update(chemical, fn i -> {i, i - ammount} end) |> elem(1)}
    end
  end

  def number_of_batches(batch, need) do
    base_batches = div(need, batch)

    batches_to_make =
      if rem(need, batch) == 0 do
        base_batches
      else
        base_batches + 1
      end

    batches_to_make
  end

  def fuel_for_ore(recipies, ore) do
    0
  end
end
