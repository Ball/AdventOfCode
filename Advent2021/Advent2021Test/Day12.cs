global using Sprache;
global using System.Collections.Generic;

namespace Advent2021Test;

public class Day12
{
    string example = @"start-A
start-b
A-c
A-b
b-d
A-end
b-end";
    [Fact(Skip="Rules Changed")]
    public void Part01Partial()
    {
        var trail = new Stack<Node>();
        trail.Push(new Node("start"));

        trail.IsValid().Should().BeTrue();
        trail.Push(new Node("A"));
        trail.IsValid().Should().BeTrue();
        trail.Push(new Node("end"));
        trail.IsValid().Should().BeTrue();
        trail.Pop();
        trail.Push(new Node("b"));
        trail.Push(new Node("A"));
        trail.IsValid().Should().BeTrue();
        trail.Push(new Node("b"));
        trail.IsValid().Should().BeFalse();
    }
    [Fact]
    public void Part01Connections(){
        var cave = new Cave(example);
        var c = cave.ConnectionsWith(new Node("start"));
        c.Should().HaveCount(2);
        cave.ConnectionsWith(new Node("A")).Should().HaveCount(4);
    }
    [Fact(Skip="Rules Changed")]
    public void Part01Example()
    {
        var cave = new Cave(example);
        cave.Pathfind();
        cave.Paths.Count().Should().Be(10);
    }
    [Fact(Skip = "Rules Changed")]
    public void Part01()
    {
        var cave = new Cave(System.IO.File.ReadAllText("data/day12.txt"));
        cave.Pathfind();
        cave.Paths.Count().Should().Be(5333);
    }
    [Fact]
    public void Part02Example()
    {
        var cave = new Cave(example);
        cave.Pathfind();
        cave.Paths.Count().Should().Be(36);
    }
    [Fact]
    public void Part02()
    {
        var cave = new Cave(System.IO.File.ReadAllText("data/day12.txt"));
        cave.Pathfind();
        cave.Paths.Count().Should().Be(146553);
    }
}
public struct Node
{
    public string Name;
    public bool IsSmall => Name.ToLower() == Name;
    public bool IsLarge => Name.ToUpper() == Name;
    public Node(string name)
    {
        Name = name;
    }
}
public static class PathExtensions
{
    public static bool IsValid(this Stack<Node> self)
    {
            var smallCaves = self
                .Where(n => n.IsSmall)
                .Select(s => s.Name)
                .ToArray();
            var count = smallCaves.Count();
            var unique = smallCaves.Distinct().Count();
            var startCount = smallCaves.Count(c => c == "start");
            return count == unique || count == (unique + 1) && startCount == 1;
    }
}
public struct Connection
{
    public Node Start;
    public Node End;
    public Connection(Node a, Node b)
    {
        Start = a.Name.CompareTo(b.Name) == -1 ? a : b;
        End = a.Name.CompareTo(b.Name) == 1 ? a : b;
    }

    public bool IsEnd => Start.Name == "end" || End.Name == "end";

    public bool Contains(Node node)
    {
        return Start.Name == node.Name || End.Name == node.Name;
    }

    public Node OtherEnd(Node a)
    {
        if (a.Name == Start.Name)
            return End;
        if (a.Name == End.Name)
            return Start;
        throw new System.NotImplementedException("----");
    }
}
public struct PathFinder
{
    readonly Cave _cave;
    Node _currentNode;
    public Stack<Node> _path = new Stack<Node>();

    public bool IsValid => _path.IsValid();

    public bool IsFinished => _currentNode.Name == "end";
    public PathFinder(Cave cave)
    {
        _cave = cave;
        _currentNode = new Node("start");
        _path.Push(_currentNode);
    }
    public PathFinder(Cave cave, Stack<Node> path, Node currentNode)
    {
        _cave = cave;
        _currentNode = currentNode;
        _path = path;
        _path.Push(currentNode);
    }
    public IEnumerable<PathFinder> Candidates()
    {
        var cave = _cave;
        var leavingNode = _currentNode;
        var path = new Stack<Node>(_path);
        // var connections = _cave.ConnectionsWith(_currentNode).ToArray();
        // var newPaths = connections.Select(c => new PathFinder(cave, path, c.OtherEnd(leavingNode))).ToArray();
        // var validPaths = newPaths.Where(p => p.IsValid).ToArray();

        // TODO write as yield
        return _cave.ConnectionsWith(_currentNode)
            .Select(c => new PathFinder(cave, new Stack<Node>(path), c.OtherEnd(leavingNode)))
            .Where(p => p.IsValid);
    }
}

public class Cave
{
    public Stack<PathFinder> _openPaths = new Stack<PathFinder>();
    public List<PathFinder> _closedPaths = new List<PathFinder>();
    public List<PathFinder> Paths => _closedPaths;
    static Parser<Node> _nodeParser = Parse.Identifier(Parse.Letter, Parse.Letter).Select(name => new Node(name));
    static Parser<Connection> _connectionParser =
        from a in _nodeParser
        from _ in Parse.Char('-')
        from b in _nodeParser
        select new Connection(a, b);
    static Parser<IEnumerable<Connection>> _inputParser = _connectionParser.DelimitedBy(Parse.LineEnd);
    private readonly Connection[] _connections;
    private readonly Node[] _nodes;

    public Cave(string input)
    {
        _connections = _inputParser.Parse(input).ToArray();
        _nodes = _connections.SelectMany(c => new[] { c.Start, c.End }).Distinct().ToArray();
    }
    public IEnumerable<Connection> ConnectionsWith(Node node)
    {
        return _connections.Where(c => c.Contains(node));
    }
    public void Pathfind()
    {
        _openPaths.Push(new PathFinder(this));
        while (_openPaths.Count > 0)
        {
            var path = _openPaths.Pop();
            if (path.IsFinished)
            {
                _closedPaths.Add(path);
            }
            else
            {
                var candidates = path.Candidates().ToArray();
                foreach (var c in candidates)
                {
                    _openPaths.Push(c);
                }
            }
        }
    }
}