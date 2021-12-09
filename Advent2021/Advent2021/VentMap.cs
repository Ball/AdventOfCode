using System.Globalization;
using System.Linq.Expressions;
using System;
using Sprache;
namespace Advent2021;

public class VentMap
{
    int[,] _map;

    Parser<IEnumerable<VentLine>> lineParser =
      (from a in VentLine.VentLineParser
       from _ in Parse.String("\n").Optional()
       select a).Many();

    public VentMap(string lines)
    {
        var vents = lineParser.Parse(lines);
        // var vents = lines.Select(l => new VentLine(l)).ToArray();
        var x = vents.Max(v => v.MaxX);
        var y = vents.Max(v => v.MaxY);
        _map = new int[x + 1, y + 1];

        foreach (var line in vents)
        {
            line.Mark(_map);
        }
    }

    public IEnumerable<int> DangerousPoints => _map.Cast<int>().Where(i => i > 1);

}
public class VentLine
{
    int _startX;
    int _startY;
    int _endX;
    int _endY;
    public int MaxX => Math.Max(_startX, _endX);
    public int MaxY => Math.Max(_startY, _endY);

    public bool IsValid => _startX == _endX || _startY == _endY;

    static readonly Parser<Point> pointParser =
        from x in Parse.Decimal.Select(int.Parse)
        from _ in Parse.Char(',')
        from y in Parse.Decimal.Select(int.Parse)
        select new Point(x, y);

    public static readonly Parser<VentLine> VentLineParser =
        from p1 in pointParser
        from _b in Parse.String(" -> ")
        from p2 in pointParser
        select new VentLine(p1, p2);

    public VentLine(Point start, Point end){
        _startX = start.X;
        _startY = start.Y;
        _endX = end.X;
        _endY = end.Y;
    }

    public void Mark(int[,] map)
    {
        foreach (var point in VentRange())
        {
            map[point.X, point.Y]++;
        }
    }

    public IEnumerable<Point> VentRange()
    {
        if (_startX == _endX)
        {
            return Enumerable.Range(Math.Min(_startY, _endY), Math.Abs(_startY - _endY) + 1).Select(y => new Point(_startX, y));
        }
        else if (_startY == _endY)
        {
            return Enumerable.Range(Math.Min(_startX, _endX), Math.Abs(_startX - _endX) + 1).Select(x => new Point(x, _startY));
        }
        var xs = Enumerable.Range(Math.Min(_startX, _endX), Math.Abs(_startX - _endX) + 1);
        if (_startX > _endX)
            xs = xs.Reverse();
        var ys = Enumerable.Range(Math.Min(_startY, _endY), Math.Abs(_startY - _endY) + 1);
        if (_startY > _endY)
            ys = ys.Reverse();
        return xs.Zip(ys).Select(i => new Point(i.First, i.Second));
    }

}

public class Point
{
    public int X;
    public int Y;
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
}