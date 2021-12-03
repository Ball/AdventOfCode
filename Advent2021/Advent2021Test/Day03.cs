namespace Advent2021Test;
public class Day03
{
    static string sampleReport = @"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010";

    [Fact]
    public void ShouldCalculateGamma(){
        var diagnostic = new Diagnostic();
        diagnostic.Report(sampleReport);

        diagnostic.Epsilon.Should().Be(9);
        diagnostic.Gamma.Should().Be(22);
        (diagnostic.Epsilon * diagnostic.Gamma).Should().Be(198);
    }
    [Fact]
    public void ShouldCalcLifeSupport(){
        var diagnostic = new Diagnostic();
        diagnostic.Report(sampleReport);
        diagnostic.C02ScrubberRating.Should().Be(10);
        diagnostic.O2Rating.Should().Be(23);
        (diagnostic.O2Rating * diagnostic.C02ScrubberRating).Should().Be(230);
    }
    [Fact]
    public void Day03Part01(){
        var diagnostic = new Diagnostic();
        diagnostic.Report(System.IO.File.ReadAllText("data/day03.txt"));
        (diagnostic.Epsilon * diagnostic.Gamma).Should().Be(841526);
    }
    [Fact]
    public void Day03Part02(){
        var diagnostic = new Diagnostic();
        diagnostic.Report(System.IO.File.ReadAllText("data/day03.txt"));
        (diagnostic.O2Rating * diagnostic.C02ScrubberRating).Should().Be(4790390);        
    }
}