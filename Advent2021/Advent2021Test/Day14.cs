using System.Text;
namespace Advent2021Test;

public class Day14
{
    string example = @"NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C";
    [Fact]
    public void Part01Example()
    {
        var p = Polymerizer.InputParser.Parse(example);
        p.React();
        p.Polymer.Should().Be("NCNBCHB");
        p.React();
        p.Polymer.Should().Be("NBCCNBBBCBHCB");
        p.React();
        p.Polymer.Should().Be("NBBBCNCCNBBNBNBBCHBHHBCHB");
        p.React();
        p.Polymer.Should().Be("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB");
    }
    [Fact]
    public void Part02ExampleViaPairs(){
        var p = Polymerizer.InputParser.Parse(example);
        var counts = p.Count(3);
        counts['N'].Should().Be(5);
        counts['C'].Should().Be(5);
        counts['B'].Should().Be(11);
        counts['H'].Should().Be(4);
    }
    [Fact]
    public void Part01ViaTest()
    {
        var p = Polymerizer.InputParser.Parse(System.IO.File.ReadAllText("data/day14.txt"));
        var counts = p.Count(10);
        var min = counts.Values.Min();
        var max = counts.Values.Max();
        (max - min).Should().Be(2740);
    }
    [Fact]
    public void Part01()
    {
        var p = Polymerizer.InputParser.Parse(System.IO.File.ReadAllText("data/day14.txt"));
        foreach (var _ in Enumerable.Repeat('.', 10))
        {
            p.React();
        }
        var chars = p.Polymer.Distinct();
        var counts = new Dictionary<char, int>();
        foreach (var c in p.Polymer.Distinct())
        {
            counts[c] = 0;
        }
        foreach (var c in p.Polymer)
        {
            counts[c]++;
        }
        var min = counts.Values.Min();
        var max = counts.Values.Max();
        (max - min).Should().Be(2740);

    }
    [Fact]
    public void Part02()
    {
        var p = Polymerizer.InputParser.Parse(System.IO.File.ReadAllText("data/day14.txt"));
        var counts = p.Count(40);
        var min = counts.Values.Min();
        var max = counts.Values.Max();
        (max - min).Should().Be(2959788056211L);
    }

}
public static class DictionaryExtensions
{
    public static void Inc<T>(this Dictionary<T, int> self, T c) where T : notnull
    {
        if (!self.ContainsKey(c))
        {
            self[c] = 0;
        }
        self[c]++;
    }
    public static void Dec<T>(this Dictionary<T,int> self, T c) where T : notnull
    {
        if(!self.ContainsKey(c)){
            self[c] = 0;
        }
        self[c]--;
    }
}

public class Polymerizer
{
    static Parser<Reaction> _reactionParser =
        from input in Parse.Letter.Repeat(2).Select(cs => new string(cs.ToArray()))
        from _ in Parse.String(" -> ")
        from result in Parse.Letter.Select(System.Convert.ToString)
        select new Reaction(input, result);
    static Parser<IEnumerable<Reaction>> _reactionsParser = _reactionParser.DelimitedBy(Parse.LineEnd);
    public static Parser<Polymerizer> InputParser =
        from start in Parse.Letter.Many().Select(cs => new string(cs.ToArray()))
        from _ in Parse.LineEnd.Repeat(2)
        from reactions in _reactionsParser
        select new Polymerizer(start, reactions);
    public Dictionary<string, Reaction> Reactions;
    Dictionary<string,long> _rCounts = new Dictionary<string, long>();

    string _polymer;
    public string Polymer => _polymer;
    public Polymerizer(string start, Dictionary<string, Reaction> reactions)
    {
        _polymer = start;
        Reactions = reactions;
    }
    public Polymerizer(string start, IEnumerable<Reaction> reactions)
    {
        _polymer = start;
        Reactions = reactions.ToDictionary(r => r.Input, r => r);
        foreach(var pair in _polymer.Zip(_polymer.Skip(1)).Select(a => new string(new char[]{a.First,a.Second}))){
            if(!_rCounts.ContainsKey(pair)){
                _rCounts[pair] = 0;
            }
            _rCounts[pair]++;
        }
    }
    public Dictionary<char,long> Count(int depth)
    {
        for(var i=0; i < depth; i++){
            ExpandForCount();
        }
        return CountChars();
    }
    public void ExpandForCount()
    {
        foreach(var pair in _rCounts.ToArray()){
            string reactionSource = pair.Key;
            var r = Reactions[reactionSource].Result;
            long occuranceCount = pair.Value;

            _rCounts[pair.Key] -= occuranceCount;

            var fistPair = pair.Key[0].ToString() + r;
            var secondPair = r + pair.Key[1];

            if(!_rCounts.ContainsKey(fistPair)){
                _rCounts[fistPair] = 0;
            }
            if(!_rCounts.ContainsKey(secondPair)){
                _rCounts[secondPair] = 0;
            }
            _rCounts[fistPair] += pair.Value;
            _rCounts[secondPair] += pair.Value;
        }

    }
    public Dictionary<char,long> CountChars()
    {
        var counts = new Dictionary<char,long>();

        foreach(var pair in _rCounts) {
            var a = pair.Key[0];
            var b = pair.Key[1];

            if(!counts.ContainsKey(a))
                counts[a] = 0;
            if(!counts.ContainsKey(b))
                counts[b] = 0;
            counts[a] += pair.Value;
            counts[b] += pair.Value;
        }

        counts[_polymer[0]]++;
        counts[_polymer[_polymer.Length-1]]++;
        foreach(var pair in counts.ToArray()){
            counts[pair.Key] /= 2;
        }
        return counts;
    }
    public void React()
    {
        var sourceIndex = 0;
        var buffer = new StringBuilder();
        do
        {
            buffer.Append(_polymer[sourceIndex]);
            var pair = _polymer.Substring(sourceIndex, 2);
            buffer.Append(Reactions[pair].Result);
            sourceIndex++;
        } while (sourceIndex + 1 < _polymer.Length);
        buffer.Append(_polymer[sourceIndex]);
        _polymer = buffer.ToString();
    }
}

public class Reaction
{
    string _input;
    string _result;
    public string Result => _result;
    public string Input => _input;
    public Reaction(string input, string result)
    {
        _input = input;
        _result = result;
    }
    public bool IsMatch(string polymer, int index)
    {
        return polymer.Substring(index, 2) == _input;
    }
}