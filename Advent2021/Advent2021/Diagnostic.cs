namespace Advent2021;

public class Diagnostic
{
    public int _gamma;
    public int _epsilon;
    public int _o2Rating;
    public int _c02ScrubberRating;
    public int Epsilon => _epsilon;
    public int Gamma => _gamma;
    public int O2Rating => _o2Rating;
    public int C02ScrubberRating => _c02ScrubberRating;

    public void Report(string report)
    {
        var lines = report.Split('\n');
        var medianTarget = lines.Length / 2;
        var width = lines[0].Length;
        var oneCounts = new int[width];
        foreach (var line in lines)
        {
            for (var i = 0; i < width; i++)
            {
                if ('1' == line[i])
                {
                    oneCounts[i]++;
                }
            }
        }

        for (var i = 0; i < width; i++)
        {
            _epsilon <<= 1;
            _gamma <<= 1;
            if (oneCounts[i] > medianTarget)
            {
                _gamma += 1;
            }
            else
            {
                _epsilon += 1;
            }
        }

        FindC02ScrubberRating(width, lines);
        Find02GeneratorRating(width, lines);
    }
    public void FindC02ScrubberRating(int width, string[] lines)
    {
        var candidate = lines.ToList();
        for (var i = 0; i < width; i++)
        {
            if (candidate.Count > 2)
            {
                var oneCount = candidate.Count(c => c[i] == '1');
                var leastCommon = (oneCount <= candidate.Count / 2) ? '1' : '0';
                candidate = candidate.Where(l => l[i] == leastCommon).ToList();
            }
            else
            {
                candidate = candidate.Where(l => l[i] == '0').ToList();
            }
            if (candidate.Count == 1)
            {
                _c02ScrubberRating = Convert.ToInt32(candidate[0], 2);
            }
        }
    }
    public void Find02GeneratorRating(int width, string[] lines)
    {
        var candidate = lines.ToList();
        for (var i = 0; i < width; i++)
        {
            if (candidate.Count > 2)
            {
                var oneCount = candidate.Count(c => c[i] == '1');
                var mostCommon = (oneCount > candidate.Count / 2) ? '1' : '0';
                candidate = candidate.Where(l => l[i] == mostCommon).ToList();
            }
            else
            {
                candidate = candidate.Where(l => l[i] == '1').ToList();
            }
            if (candidate.Count == 1)
            {
                _o2Rating = Convert.ToInt32(candidate[0], 2);
            }
        }

    }
}