namespace Advent2021;

public class Sonar{
    public Sonar(){

    }
    public int ReportOnWindow(int[] readings){
        var windowedData = readings
            .Zip(readings.Skip(1))
            .Zip(readings.Skip(2))
            .Select(a => a.Second + a.First.First + a.First.Second)
            .ToArray();
        return Report(windowedData);
    }
    public int Report(int[] readings){
        return readings.Zip(readings.Skip(1))
            .Select(a => a.First < a.Second)
            .Where(x => x)
            .Count();
    }
}