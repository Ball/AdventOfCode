
namespace Advent2021Test;

public class Day11
{
    int[][] input = new int[][]{
        new []{1,4,4,3,6,6,8,6,4,6},
        new []{7,6,8,6,7,3,5,7,1,6},
        new []{4,2,6,1,5,7,6,2,3,1},
        new []{3,3,6,1,2,5,8,6,5,4},
        new []{4,8,5,2,5,3,2,6,1,1},
        new []{5,5,8,7,1,1,3,7,3,2},
        new []{1,2,2,4,4,2,6,7,5,7},
        new []{5,1,5,5,5,6,5,1,3,3},
        new []{6,4,8,8,3,7,7,8,6,2},
        new []{8,2,6,7,8,3,3,8,1,1}};

    [Fact]
    public void Part01()
    {
        var o =  new Octipodes(input);
        foreach(var i in Enumerable.Range(0,100)){
            o.Step();
        }
        o.FlashCount().Should().Be(1743);
    }
    [Fact]
    public void Part02(){
        var o = new Octipodes(input);
        var count = 0;
        do{
            o.Step();
            count++;
        }while(!o.Synced);
        count.Should().Be(364);
    }
}

public class Octopus
{
    int x;
    int y;
    int energy;
    public int Energy => energy;
    bool hasFlashed;
    int flashCount;
    public int FlashCount => flashCount;
    public Octipodes collection;
    public Octopus(Octipodes collection, int x, int y, int energy)
    {
        this.x = x;
        this.y = y;
        this.energy = energy;
        this.collection = collection;
    }
    public void Tick()
    {
        energy++;
        if (energy > 9 && !hasFlashed)
        {
            hasFlashed = true;
            flashCount++;
            collection.ActivateNeighbors(x, y);
        }

    }
    public void Tok()
    {
        hasFlashed = false;
        if (energy > 9)
        {
            energy = 0;
        }
    }
}
public class Octipodes
{
    Octopus[][] octopuses;
    public Octipodes(int[][] energyReadings)
    {
        octopuses = new Octopus[10][];
        for (var y = 0; y < 10; y++)
        {
            octopuses[y] = new Octopus[10];
            for (var x = 0; x < 10; x++)
            {
                octopuses[y][x] = new Octopus(this, x, y, energyReadings[y][x]);
            }
        }
    }
    public bool Synced =>
            octopuses.SelectMany(o => o).All(o => o.Energy == 0);
    public int FlashCount() =>
        octopuses.SelectMany(o => o).Select(o => o.FlashCount).Sum();
    public void ActivateNeighbors(int x, int y)
    {
        foreach(var ny in Enumerable.Range(y-1,3)){
            foreach(var nx in Enumerable.Range(x-1, 3)){
                if(nx >= 0 && nx < 10 && ny >= 0 &&  ny < 10){
                    if(nx != x || ny != y){
                        octopuses[ny][nx].Tick();
                    }
                }
            }
        }

    }
    public void Step()
    {
        for (var y = 0; y < 10; y++)
        {
            for (var x = 0; x < 10; x++)
            {
                octopuses[y][x].Tick();
            }
        }

        for (var y = 0; y < 10; y++)
        {
            for (var x = 0; x < 10; x++)
            {
                octopuses[y][x].Tok();
            }
        }
    }
}