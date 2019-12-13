defmodule Day13Test do
    use ExUnit.Case, async: true

    test "count blocks at the end" do
        assert 380 == Day13.count_blocks()
    end
    @tag skip: "not implmemented"
    test "play whole game" do
        assert 0 == Day13.play_whole_game()
    end
end
