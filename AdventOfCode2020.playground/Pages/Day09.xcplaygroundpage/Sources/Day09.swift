import Foundation


public func check(numbers: [Int], withWindow window: Int) -> [(Int,Int,Bool)] {
    var results = [(Int, Int, Bool)]()
    
    for i in window..<numbers.count {
        let windowContents:[Int] = numbers.dropFirst(i - window).prefix(window).map{$0}
        let target = numbers[i]
        var valid = false
        OUTER: for j in 0..<(windowContents.count-1) {
            for k in (j+1)..<windowContents.count {
                if (windowContents[j] + windowContents[k]) == target {
                    valid = true
                    break OUTER
                }
            }
        }
        results.append((i, target, valid))
    }
    
    return results
}
public func findSumRun(ofN n: Int, overRange range: [Int]) -> [Int] {
    for i in 0..<(range.count-1) {
        for j in (i)..<range.count{
            
            let run = range.dropFirst(i).prefix(j)
            if n == run.reduce(0, {$0 + $1}) {
                return run.map{$0}
            }
        }
    }
    return []
}
