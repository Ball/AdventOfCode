namespace Advent2021Test;

public class GuidanceTest{
    [Fact(Skip="Changed")]
    public void ShouldStepDown(){
        var guidance = new Guidance();
        guidance.Step("down 5");
        guidance.Depth.Should().Be(5);
    }
    [Fact(Skip="Changed")]
    public void ShouldStepDownThenUp(){
        var guidance = new Guidance();
        guidance.Step("down 5");
        guidance.Step("up 2");
        guidance.Depth.Should().Be(3);
    }
    [Fact]
    public void ShouldStepForward(){
        var guidance = new Guidance();
        guidance.Step("forward 4");
        guidance.Position.Should().Be(4);
    }
    [Fact]
    public void ShouldMoveToExample(){
        var guidance = new Guidance();
        var steps = new[]{
"forward 5",
"down 5",
"forward 8",
"up 3",
"down 8",
"forward 2"
        };
        guidance.Move(steps);
        guidance.Position.Should().Be(15);
        guidance.Depth.Should().Be(60);
        (guidance.Position * guidance.Depth).Should().Be(900);
        // (guidance.Position * guidance.Depth).Should().Be(150);
    }
    [Fact(Skip = "Submitted, but no longer passing")]
    public void Day02Part01(){
        var data = System.IO.File.ReadLines("data/day02.txt").ToArray();
        var guidance = new Guidance();
        guidance.Move(data);
        (guidance.Position * guidance.Depth).Should().Be(1636725);
    }
    [Fact]
    public void Day02Part02(){
        var data = System.IO.File.ReadLines("data/day02.txt").ToArray();
        var guidance = new Guidance();
        guidance.Move(data);
        (guidance.Position * guidance.Depth).Should().Be(1872757425);
    }
}