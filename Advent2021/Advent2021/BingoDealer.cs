using System.Collections.Generic;
namespace Advent2021;

public class BingoCaller{
    List<BingoBoard> _boards;
    private readonly int[] _calls;

    public List<BingoBoard> Borads => _boards;

    public BingoCaller(string[] lines){
        _boards = new List<BingoBoard>();
        _calls = lines[0].Split(',').Select(Int32.Parse).ToArray();
        for(var i = 1; i < lines.Length;){
            _boards.Add(BuildBoard(ref i, lines));
        }
    }

    public BingoBoard BuildBoard(ref int index, string[] lines){
        var board = new BingoBoard(lines.Skip(index+1).Take(5).ToArray());
        index += 6;
        return board;
    }

    public Tuple<int,BingoBoard> Play(){
        var callIndex = 0;
        var lastCalled = 0;
        var winningBoards = new List<BingoBoard>();
        do{
            lastCalled = _calls[callIndex++];
            foreach(var board in _boards){
                board.Mark(lastCalled);
                if(!winningBoards.Contains(board) && board.HasBingo){
                    winningBoards.Add(board);
                }
            }
        }while(_boards.Any(b => !b.HasBingo));
        return new Tuple<int, BingoBoard>(lastCalled, winningBoards.Last());
    }
}
public class BingoBoard{
    public string AsString => string.Join("\n", _cells.Select( row => string.Join(" ", row.Select(c => c.IsMarked ? "X" : c.Number.ToString()))));
    private readonly BingoCell[][] _cells;
    public bool HasBingo => CheckRows || CheckColumns;
    public bool CheckRows => _cells.Any(row => row.All(cell => cell.IsMarked));
    public bool CheckColumns => Enumerable.Range(0,5).Any(i => _cells.All(r => r[i].IsMarked));
    
    public int Score(int lastCalled){
        return lastCalled * _cells.SelectMany(c => c).Where(c => !c.IsMarked).Select(c => c.Number).Sum();
    }

    public BingoBoard(string[] lines){
        _cells = lines.Select(l => l.TrimStart().Split(" ", options: StringSplitOptions.RemoveEmptyEntries).Select(Int32.Parse).Select(n => new BingoCell(n)).ToArray()).ToArray();
    }
    public void Mark(int n){
        foreach(var cell in _cells.SelectMany(r => r)){
            cell.Mark(n);
        }
    }
}
public class BingoCell{
    int _number;
    bool _isMarked;
    public bool IsMarked => _isMarked;
    public int Number => _number;
    public BingoCell(int n){
        _number = n;
    }
    public void Mark(int n){
        if(n == _number){
            _isMarked = true;
        }
    }
}