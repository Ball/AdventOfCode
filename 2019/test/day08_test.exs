defmodule Day08Test do
  use ExUnit.Case, async: true

  test "Load an Image" do
    image = "123456789012"
            |> Day08.load_image(3,2)
    assert image == [[[1,2,3],[4,5,6]],[[7,8,9],[0,1,2]]]

  end

  test "validate image" do
    assert 2286 == Day08.validate_image()
  end

  test "merge image" do
    assert [[0,1],[1,0]] == "0222112222120000" |> Day08.load_image(2,2) |> Day08.merge_image()

  end

  test "decode image" do
    assert Day08.decode_image() == """
0110000110111101000011100
1001000010000101000010010
1000000010001001000010010
1000000010010001000011100
1001010010100001000010000
0110001100111101111010000
"""
  end
end
