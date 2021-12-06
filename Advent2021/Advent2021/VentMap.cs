namespace Advent2021;

public class VentMap{
    int[,] _map;
    public VentMap(string[] lines){
        var vents = lines.Select(l => new VentLine(l)).ToArray();
        var x = vents.Max(v => v.MaxX);
        var y = vents.Max(v => v.MaxY);
        _map = new int[x+1,y+1];
    
        foreach(var line in lines.Select(l => new VentLine(l))){
            line.Mark(_map);
        }
    }

    public IEnumerable<int> DangerousPoints => _map.Cast<int>().Where(i => i>1);

}
public class VentLine{
    int _startX;
    int _startY;
    int _endX;
    int _endY;
    public int MaxX => Math.Max(_startX, _endX);
    public int MaxY => Math.Max(_startY, _endY);

    public bool IsValid => _startX == _endX || _startY == _endY;
    public VentLine(string def){
        var points = def.Split(" -> ");
        var startParts = points[0].Split(",");
        var endParts = points[1].Split(",");
        _startX = int.Parse(startParts[0]);
        _startY = int.Parse(startParts[1]);
        _endX = int.Parse(endParts[0]);
        _endY = int.Parse(endParts[1]);
    }

    public void Mark(int[,] map){
        foreach(var point in VentRange()){
            map[point.X,point.Y]++;
        }

    }
    public IEnumerable<Point> VentRange(){
        if(_startX == _endX){
            return Enumerable.Range(Math.Min(_startY, _endY), Math.Abs(_startY - _endY)+1).Select(y => new Point(_startX, y));
        }
        else if(_startY == _endY){
            return Enumerable.Range(Math.Min(_startX, _endX), Math.Abs(_startX - _endX)+1).Select(x => new Point(x, _startY));
        }
        var xs = Enumerable.Range(Math.Min(_startX, _endX), Math.Abs(_startX - _endX)+1);
        if(_startX > _endX)
            xs = xs.Reverse();
        var ys = Enumerable.Range(Math.Min(_startY, _endY), Math.Abs(_startY - _endY)+1);
        if(_startY > _endY)
            ys = ys.Reverse();
        return xs.Zip(ys).Select( i => new Point(i.First, i.Second));
    }

}
public class Point{
    public int X;
    public int Y;
    public Point(int x, int y){
        X = x;
        Y = y;
    }
}