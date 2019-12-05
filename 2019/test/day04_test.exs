defmodule Day04Test do
    use ExUnit.Case, async: true

    test "validates never decreasing" do
        assert Day04.validate_never_decrease(111111) == true
        assert Day04.validate_never_decrease(223450) == false
        assert Day04.validate_never_decrease(123789) == true
    end

    test "validates duplicates" do
        assert Day04.validates_doubles(112233) == true
        assert Day04.validates_doubles(123444) == false
        assert Day04.validates_doubles(111122) == true

        assert Day04.validates_doubles(111111) == false
        assert Day04.validates_doubles(223450) == true
        assert Day04.validates_doubles(123789) == false
    end

    test "validates multiples" do
        assert Day04.validates_multiples(111111) == true
        assert Day04.validates_multiples(223450) == true
        assert Day04.validates_multiples(123789) == false
    end

    test "count valid in range" do
        assert Day04.count_valid_in_range(234208, 765869) == 1246
    end
    test "count stricter in range" do
        assert Day04.count_strictly_valid_in_range(234208, 765869) == 814
    end
end