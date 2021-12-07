namespace Advent2021Test;

using System.Collections.Generic;
using System.Threading.Tasks;
using System.Threading;
using System;

public class Day06 {
    int[] fish = new int[]{1,1,1,1,1,1,1,4,1,2,1,1,4,1,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,3,1,1,2,1,2,1,3,3,4,1,4,1,1,3,1,1,5,1,1,1,1,4,1,1,5,1,1,1,4,1,5,1,1,1,3,1,1,5,3,1,1,1,1,1,4,1,1,1,1,1,2,4,1,1,1,1,4,1,2,2,1,1,1,3,1,2,5,1,4,1,1,1,3,1,1,4,1,1,1,1,1,1,1,4,1,1,4,1,1,1,1,1,1,1,2,1,1,5,1,1,1,4,1,1,5,1,1,5,3,3,5,3,1,1,1,4,1,1,1,1,1,1,5,3,1,2,1,1,1,4,1,3,1,5,1,1,2,1,1,1,1,1,5,1,1,1,1,1,2,1,1,1,1,4,3,2,1,2,4,1,3,1,5,1,2,1,4,1,1,1,1,1,3,1,4,1,1,1,1,3,1,3,3,1,4,3,4,1,1,1,1,5,1,3,3,2,5,3,1,1,3,1,3,1,1,1,1,4,1,1,1,1,3,1,5,1,1,1,4,4,1,1,5,5,2,4,5,1,1,1,1,5,1,1,2,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,5,1,1,1,1,1,1,3,1,1,2,1,1};

    [Fact]
    public void Day06Part01(){
        var school = new List<int>(fish);
        for(var t = 0; t < 80; t++){
            var newFish = 0;
            Parallel.For(0, school.Count, index => {
                school[index]--;
                if(school[index] == -1){
                    Interlocked.Increment(ref newFish);
                    school[index] = 6;
                }
            });
            school.AddRange(Enumerable.Repeat(8, newFish));
        }
        school.Should().HaveCount(389726);
    }
    [Fact]
    public void Day06Part01Method2(){
        var school = Enumerable.Range(0,9)
            .Select(  i => new Tuple<int,int>(i, fish.Where(n => n == i).Count()))
            .ToArray();
        for(var t = 0; t < 80; t++){
            school = school.SelectMany( t => {
                if(t.Item1 == 0){
                    return new[]{new Tuple<int,int>(8,t.Item2), new Tuple<int, int>(6,t.Item2)};
                }
                return new[]{new Tuple<int,int>(t.Item1-1, t.Item2)};
            }).ToArray();
        }
        school.Sum(p => p.Item2).Should().Be(389726);
    }
    [Fact]
    public void Day06Part01Method3(){
        var school = Enumerable.Range(0,9)
            .Select(  i => fish.Where(n => n == i).Count())
            .ToArray();
        
        for(var t = 0; t < 80; t++){

            var spawningFish = 0;
            for(var age = 0; age < 9; age++){
                if(age == 0){
                    spawningFish = school[age];
                }else{
                    school[age-1] = school[age];
                }
            }
            school[8] = spawningFish;
            school[6] += spawningFish;
        }
        school.Sum().Should().Be(389726);
    }
    [Fact]
    public void Day06Part02Method3(){
        long[] school = Enumerable.Range(0,9)
            .Select(  i => Convert.ToInt64(fish.Where(n => n == i).Count()))
            .ToArray();
        
        for(var t = 0; t < 256; t++){

            long spawningFish = 0;
            for(var age = 0; age < 9; age++){
                if(age == 0){
                    spawningFish = school[age];
                }else{
                    school[age-1] = school[age];
                }
            }
            school[8] = spawningFish;
            school[6] += spawningFish;
        }
        school.Sum().Should().Be(1743335992042L);
    }
    [Fact(Skip = "Too long")]
    public void Day06Part02(){
        var school = new List<int>(fish);
        for(var t = 0; t < 256; t++){
            var newFish = 0;
            Parallel.For(0, school.Count, index => {
                school[index]--;
                if(school[index] == -1){
                    Interlocked.Increment(ref newFish);
                    school[index] = 6;
                }
            });
            school.AddRange(Enumerable.Repeat(8, newFish));
        }
        school.Should().HaveCount(389726);
    }
}