global using Xunit;
global using Advent2021;
global using FluentAssertions;
global using System.Linq;
namespace Advent2021Test;
public class SonarTest
{
    [Fact]
    public void ShouldReportIncrements()
    {
        new Sonar()
        .Report(new[] { 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 })
        .Should().Be(7);
    }

    [Fact]
    public void ShouldReportOnSlidingWindow()
    {
        new Sonar()
        .ReportOnWindow(new[] { 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 })
        .Should().Be(5);
    }

    [Fact(Skip = "Submitted")]
    public void Day01Part01()
    {
        var data = System.IO.File.ReadLines("data/day01.txt")
        .Select(line => line.Trim())
        .Select(s => System.Convert.ToInt32(s))
        .ToArray();

        new Sonar()
        .Report(data)
        .Should().Be(1301);
    }

    [Fact(Skip = "Submitted")]
    public void Day01Part02(){
        var data = System.IO.File.ReadLines("data/day01.txt")
        .Select(line => line.Trim())
        .Select(s => System.Convert.ToInt32(s))
        .ToArray();

        new Sonar()
        .ReportOnWindow(data)
        .Should().Be(1346);
    }
}