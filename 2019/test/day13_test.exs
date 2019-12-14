defmodule Day13Test do
    use ExUnit.Case, async: true

    test "count blocks at the end" do
        assert 380 == Day13.count_blocks()
    end

    test "play whole game" do
        assert 18647 == Day13.play_whole_game()
    end
end
