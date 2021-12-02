namespace Advent2021;

public class Guidance{
    int _x = 0;
    int _y = 0;
    int _aim = 0;

    public int Depth => _y;
    public int Position => _x;
    public int Aim => _aim;

    public void Step(string move){
        if(move.StartsWith("forward ")){
            int value = int.Parse(move.Replace("forward ", ""));
            _x += value;
            _y += _aim * value;
        } else if (move.StartsWith("down ")) {
            int value = int.Parse(move.Replace("down ", ""));
            _aim += value;
        } else if (move.StartsWith("up ")){
            int value = int.Parse(move.Replace("up ", ""));
            _aim -= value;
        }
    }
    public void Move(string[] steps){
        foreach(var step in steps){
            Step(step);
        }
    }
}