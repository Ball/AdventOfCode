
public class DisplayDigit
{
    HashSet<char> wires;
    public readonly string Raw;
    public string Digit;
    public DisplayDigit(string digit, string str)
    {
        Digit = digit;
        Raw = str;
        wires = new HashSet<char>(str.ToArray());
    }
    public bool IsDigit(string str) =>
        str.All(c => wires.Contains(c)) && str.Length == wires.Count;

    public bool CoversDigit(string str) =>
        str.All(c => wires.Contains(c));

    public bool CoveredByDigit(string str) =>
        wires.All(c => str.Contains(c));
}

public class DisplayDecoder
{
    string[] _examples;
    string[] _output;

    public string Display { get; private set; }

    DisplayDigit Zero { get; set; }
    DisplayDigit One { get; set; }
    DisplayDigit Two { get; set; }
    DisplayDigit Three { get; set; }
    DisplayDigit Four { get; set; }
    DisplayDigit Five { get; set; }
    DisplayDigit Six { get; set; }
    DisplayDigit Seven { get; set; }
    DisplayDigit Eight { get; set; }
    DisplayDigit Nine { get; set; }

    public DisplayDecoder(string source)
    {
        var parts = source.Split('|');
        _examples = parts[0].Trim().Split(' ').Select(e => string.Concat(e.OrderBy(c => c))).ToArray();
        _output = parts[1].Trim().Split(' ').Select(o => string.Concat(o.OrderBy(c => c))).ToArray();
        One = new DisplayDigit("1", _examples.First(e => e.Length == 2));
        Four = new DisplayDigit("4", _examples.First(e => e.Length == 4));
        Seven = new DisplayDigit("7", _examples.First(e => e.Length == 3));
        Eight = new DisplayDigit("8", _examples.First(e => e.Length == 7));
        var sixes = _examples.Where(e => e.Length == 6).ToHashSet();
        Six = new DisplayDigit("6", sixes.First(f => !Seven.CoveredByDigit(f)));
        sixes.Remove(Six.Raw);
        Nine = new DisplayDigit("9", sixes.First(f => Four.CoveredByDigit(f)));
        sixes.Remove(Nine.Raw);
        Zero = new DisplayDigit("0", sixes.First());
        var fives = _examples.Where(e => e.Length == 5).ToHashSet();
        Three = new DisplayDigit("3", fives.First(f => Seven.CoveredByDigit(f)));
        fives.Remove(Three.Raw);
        Five = new DisplayDigit("5", fives.First(f => Six.CoversDigit(f)));
        fives.Remove(Five.Raw);
        Two = new DisplayDigit("2", fives.First());
        var lookup = new[]{Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine};

        Display = string.Join("",_output.Select(o => lookup.First(l => l.IsDigit(o))).Select(d => d.Digit));
    }

    public int Count1478()
    {
        var wanted = new[] { One, Four, Seven, Eight };
        return _output.Where(digit => wanted.Any(w => w.IsDigit(digit))).Count();
    }
}