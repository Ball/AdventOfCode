defmodule Day06Test do
    use ExUnit.Case, async: true

    test "parse one orbit" do
      assert %{"B" => "COM"} == Day06.read_object("COM)B", %{})
    end
    test "count one extended orbit" do
      system = ["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L"]
                |> Enum.reduce(%{}, &Day06.read_object/2)
      assert "C" == Map.get(system, "D")
      assert 3 == Day06.count_orbits_for("D", system)
    end

    test "Mini System total orbits" do
        total_orbits = ["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L"]
                        |> Enum.reduce(%{}, &Day06.read_object/2)
                        |> Day06.count_all_orbits()
        assert 42 == total_orbits
    end

    test "Orbital Transfers" do
      system = ["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L","K)YOU","I)SAN"]
                |> Enum.reduce(%{}, &Day06.read_object/2)
      common_centroid = Day06.common_centroid(system, "SAN", "YOU")
      assert common_centroid == "D"
      assert 4 == Day06.distance_from_ancestor(system, "YOU", "D")
      assert 4 == Day06.transfer_distance_between(system, "YOU", "SAN")
    end
    test "transfer in large system" do
      assert 286 == Day06.transfer_distance_all_orbits_in_file()
    end
    test "large system total orbits" do
      assert 139597 == Day06.count_all_orbits_in_file()
    end
end
