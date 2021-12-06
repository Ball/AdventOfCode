namespace Advent2021Test;

public class Day05 {
    [Fact]
    public void VentLineDecoding(){
        var line = new VentLine("0,9 -> 5,9");
        line.MaxX.Should().Be(5);
        line.MaxY.Should().Be(9);

        var range = line.VentRange().ToArray();

        line = new VentLine("7,0 -> 7,4");
        range = line.VentRange().ToArray();

        line = new VentLine("9,7 -> 7,9");
        range = line.VentRange().ToArray();
    }
    [Fact]
    public void Day05Example(){
        var input = @"0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2";
        var map = new VentMap(input.Split("\n"));
        map.DangerousPoints.Should().HaveCount(12); 
    }
    [Fact(Skip = "Superseded")]
    public void Day05Part01(){
        var lines = System.IO.File.ReadAllLines("data/day05.txt");
        var map = new VentMap(lines);
        map.DangerousPoints.Should().HaveCount(6005);

    }
    [Fact]
    public void Day05Part02(){
        var lines = System.IO.File.ReadAllLines("data/day05.txt");
        var map = new VentMap(lines);
        map.DangerousPoints.Should().HaveCount(23864);

    }
}