namespace Advent2021Test;

public class Day08{
    string _example = @"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce";

    [Fact]
    public void ShouldFindUniques(){
        var decoder = new DisplayDecoder(_example.Split("\n").First());
        decoder.Count1478().Should().Be(2);
    }
    [Fact]
    public void Part01Example(){
        var decoders = _example.Split("\n")
        .Select(line => new DisplayDecoder(line)).ToArray();
        var counts = decoders
        .Select(decoder => decoder.Count1478()).ToArray();
        counts
        .Sum().Should().Be(26);
    }
    [Fact]
    public void Part01(){
        System.IO.File.ReadAllLines("data/day08.txt")
        .Select(l => new DisplayDecoder(l))
        .Select(d => d.Count1478())
        .Sum().Should().Be(369);
    }
    [Fact]
    public void Part02Example(){
        var decoder = _example.Split("\n")
            .Select(line => new DisplayDecoder(line))
            .Select(decoder => decoder.Display)
            .ToArray();
        decoder[0].Should().Be("8394");
    }
    [Fact]
    public void Part02(){
        System.IO.File.ReadAllLines("data/day08.txt")
        .Select(l => new DisplayDecoder(l))
        .Select(d => int.Parse(d.Display))
        .Sum().Should().Be(1031553);
    }

}