defmodule Day04Test do
  use ExUnit.Case, async: true

  test "validates never decreasing" do
    assert Day04.validate_never_decrease(111_111) == true
    assert Day04.validate_never_decrease(223_450) == false
    assert Day04.validate_never_decrease(123_789) == true
  end

  test "validates duplicates" do
    assert Day04.validates_doubles(112_233) == true
    assert Day04.validates_doubles(123_444) == false
    assert Day04.validates_doubles(111_122) == true

    assert Day04.validates_doubles(111_111) == false
    assert Day04.validates_doubles(223_450) == true
    assert Day04.validates_doubles(123_789) == false
  end

  test "validates multiples" do
    assert Day04.validates_multiples(111_111) == true
    assert Day04.validates_multiples(223_450) == true
    assert Day04.validates_multiples(123_789) == false
  end

  test "count valid in range" do
    assert Day04.count_valid_in_range(234_208, 765_869) == 1246
  end

  test "count stricter in range" do
    assert Day04.count_strictly_valid_in_range(234_208, 765_869) == 814
  end
end
