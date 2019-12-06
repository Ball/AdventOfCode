defmodule Day06 do
  def read_object(orbit, sys) do
    [centroid, satellite] = String.split(orbit, ")", trim: true)
    sys
    |> Map.put(satellite, centroid)
  end
  def count_all_orbits(system) do
    system
    |> Map.keys()
    |> Enum.map(fn satellite -> count_orbits_for(satellite, system) end)
    |> Enum.sum()
  end
  def count_orbits_for(satellite, system) do
    count_orbits_for(satellite, system, 0)
  end
  def count_orbits_for(satellite, system, acc) do
    if !Map.has_key?(system, satellite) do
      acc
    else
      system
      |> Map.get(satellite)
      |> count_orbits_for(system, acc + 1)
    end
  end
  def transfer_distance_between(system, satellite1, satellite2) do
    common = common_centroid(system, satellite1, satellite2)
    distance_from_ancestor(system, satellite1, common) + distance_from_ancestor(system, satellite2, common) - 2
  end
  def distance_from_ancestor(system, satellite, ancestor, acc\\0) do
    if satellite == ancestor do
      acc
    else
      distance_from_ancestor(system, Map.get(system, satellite), ancestor, acc + 1)
    end
  end
  def common_centroid(system, satellite1, satellite2) do
    path1 = path_to_center(system, satellite1)
    path2 = path_to_center(system, satellite2)
    shared_root(path1, path2)
  end
  defp shared_root([satellite1 | path1], [satellite2 | path2], shared \\ "") do
    if satellite1 == satellite2 do
      shared_root(path1, path2, satellite1)
    else
      shared
    end
  end
  def path_to_center(system, satellite), do: path_to_center(system, satellite, [])
  def path_to_center(system, satellite, path) do
    if !Map.has_key?(system, satellite) do
      path
    else
      path_to_center(system, Map.get(system, satellite), [satellite| path])
    end
  end


  def transfer_distance_all_orbits_in_file() do
    {:ok, content} = File.read("day06_input.txt")
    content
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &read_object/2)
    |> transfer_distance_between("YOU", "SAN")
  end
  def count_all_orbits_in_file() do
    {:ok, content} = File.read("day06_input.txt")
    content
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &read_object/2)
    |> count_all_orbits()
  end
end
