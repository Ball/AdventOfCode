using System.Collections.Generic;
using System.Linq;
namespace Advent2021Test;


public class ChunkScorer
{
    Stack<char> _openChunks = new Stack<char>();
    string _line;
    public ChunkScorer(string line)
    {
        _line = line;
    }

    public long ScoreIncompleteChunks(){
        foreach (var c in _line.ToArray())
        {
            switch (c)
            {
                case '(':
                    _openChunks.Push(c);
                    break;
                case '[':
                    _openChunks.Push(c);
                    break;
                case '{':
                    _openChunks.Push(c);
                    break;
                case '<':
                    _openChunks.Push(c);
                    break;
                case '>':
                    if ('<' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 0;
                    }
                    break;
                case '}':
                    if ('{' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 0;
                    }
                    break;
                case ']':
                    if ('[' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 0;
                    }
                    break;
                case ')':
                    if ('(' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 0;
                    }
                    break;
            }
        }
        return _openChunks.Select(AutoCompletePoints).Aggregate(0L, (a,b) => a * 5L + b);    
    }

    public int ScoreCorruptChunks()
    {
        foreach (var c in _line.ToArray())
        {
            switch (c)
            {
                case '(':
                    _openChunks.Push(c);
                    break;
                case '[':
                    _openChunks.Push(c);
                    break;
                case '{':
                    _openChunks.Push(c);
                    break;
                case '<':
                    _openChunks.Push(c);
                    break;
                case '>':
                    if ('<' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 25137;
                    }
                    break;
                case '}':
                    if ('{' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 1197;
                    }
                    break;
                case ']':
                    if ('[' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 57;
                    }
                    break;
                case ')':
                    if ('(' == _openChunks.Peek())
                    {
                        _openChunks.Pop();
                    }
                    else
                    {
                        return 3;
                    }
                    break;
            }
        }
        return 0;
    }
    public static long AutoCompletePoints(char c) => c switch {
        '(' => 1,
        '[' => 2,
        '{' => 3,
        '<' => 4
    };
}
public class Day10
{
    string _example = @"[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]";

    [Fact]
    public void Part01Example(){
        _example.Split("\n")
            .Select(l => new ChunkScorer(l).ScoreCorruptChunks())
            .Sum()
            .Should()
            .Be(26397);
    }
    [Fact]
    public void Part01(){
        System.IO.File.ReadAllLines("data/day10.txt")
        .Select(l => new ChunkScorer(l).ScoreCorruptChunks())
        .Sum()
        .Should()
        .Be(392043);
    }
    [Fact]
    public void Part02Example(){
        var scores = _example.Split("\n")
        .Select(l => new ChunkScorer(l).ScoreIncompleteChunks())
        .Where( s => s != 0)
        .OrderBy( s => s)
        .ToArray();
        var middleIndex = scores.Length / 2;
        scores[middleIndex].Should().Be(288957L);
    }
    [Fact]
    public void Part02(){
        var scores = System.IO.File.ReadAllLines("data/day10.txt")
        .Select(l => new ChunkScorer(l).ScoreIncompleteChunks())
        .Where( s => s != 0)
        .OrderBy( s => s)
        .ToArray();
        var middleIndex = scores.Length / 2 ;
        scores[middleIndex].Should().Be(1605968119L);
    }
}