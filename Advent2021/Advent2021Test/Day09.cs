using System.Linq;
using System.Collections.Generic;
using System;
namespace Advent2021Test;


public class Day09{
    string exampleString = @"2199943210
3987894921
9856789892
8767896789
9899965678";
    [Fact]
    public void Part01Example(){
        var cave = new LavaCave(exampleString.Split("\n")
            .Select(line => line.ToArray().Select( c=> int.Parse(char.ToString(c))).ToArray())
            .ToArray());
        cave.Prime();
        cave.Heights.Where(h => h.IsLowPoint).Select(h => h.Height + 1).Sum().Should().Be(15);
    }
    [Fact]
    public void Part01(){
        var cave = new LavaCave(System.IO.File.ReadAllLines("data/day09.txt").Select(l => l.ToArray().Select(c => int.Parse(char.ToString(c))).ToArray()).ToArray());
        cave.Prime();
        cave.Heights.Where(h => h.IsLowPoint).Select(h => h.Height +1).Sum().Should().Be(539);
    }
    [Fact]
    public void Part02Example(){
        var cave = new LavaCave(exampleString.Split("\n")
            .Select(line => line.ToArray().Select( c=> int.Parse(char.ToString(c))).ToArray())
            .ToArray());
        cave.Prime();
        var step1 = cave.Heights.Where(h => h.IsLowPoint).Select(h => h.BasinSize()).ToArray();
        var step2 = step1.OrderByDescending(h => h).ToArray();
        var step3 = step2.Take(3).ToArray();
        var step4 = step3.Aggregate((a,b) => a *b ).Should().Be(1134);
    }
    [Fact]
    public void Part02(){
        var cave = new LavaCave(System.IO.File.ReadAllLines("data/day09.txt").Select(l => l.ToArray().Select(c => int.Parse(char.ToString(c))).ToArray()).ToArray());
        
        cave.Prime();
        var step1 = cave.Heights.Where(h => h.IsLowPoint).Select(h => h.BasinSize()).ToArray();
        var step2 = step1.OrderByDescending(h => h).ToArray();
        var step3 = step2.Take(3).ToArray();
        var step4 = step3.Aggregate((a,b) => a *b ).Should().Be(736920);
    }
}
public class LavaCave{
    int _width;
    int _height;
    LavaHeight[][] _caves;
    public IEnumerable<LavaHeight> Heights => _caves.SelectMany(row => row);
    public LavaCave(int[][] heights){
        _width = heights.Length;
        _height = heights[0].Length;
        _caves = new LavaHeight[_width][];

        for(var x = 0; x < heights.Length; x++){
            _caves[x] = new LavaHeight[_height];
            for(var y = 0; y < heights[0].Length; y++){
                _caves[x][y] = new LavaHeight(this,x,y,heights[x][y]);
            }
        }
    }

    public void Prime(){
        foreach(var row in _caves){
            foreach(var cave in row){
                cave.Process();
            }
        }
    }

    public IEnumerable<LavaHeight> Neighbors(int x, int y){
        var xs = new int[]{x-1, x+1}.Where(n => n >= 0 && n < _width).Select(n => _caves[n][y]);
        var ys = new int[]{y-1, y+1}.Where(n => n >= 0 && n < _height).Select(n => _caves[x][n]);
        return xs.Concat(ys);
    }
}

public class LavaHeight{
    public int Height => _height;
    int _height;
    int _x;
    int _y;
    LavaCave _parent;
    bool _isLowPoint = false;
    public bool IsLowPoint => _isLowPoint;
    public LavaHeight(LavaCave parent, int x, int y, int height){
        _height = height;
        _x = x;
        _y = y;
        _parent = parent;
    }
    public void Process(){
        IEnumerable<LavaHeight> neighbors = _parent.Neighbors(_x, _y).ToArray();
        var thisHeight = this._height;
        _isLowPoint = neighbors.All(h => thisHeight < h.Height);
    }

    public int BasinSize(){
        var known = new HashSet<LavaHeight>();
        known.Add(this);
        BasinNeighbors(known);
        return known.Count;
    }
    public void BasinNeighbors(HashSet<LavaHeight> known) {
        var newBasinMates = _parent.Neighbors(_x,_y).Where(n => n.Height != 9).Where(n => !known.Contains(n)).ToArray();
        if(newBasinMates.Length == 0)
            return;
        known.UnionWith(newBasinMates);
        foreach(var h in newBasinMates){
            h.BasinNeighbors(known);
        }
    }

}