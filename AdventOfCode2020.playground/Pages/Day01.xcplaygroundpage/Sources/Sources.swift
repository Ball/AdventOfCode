import Foundation

public func findPairs(in numbers: [Int]) -> Int {
    for n in 0..<numbers.count {
        for m in (n+1)..<numbers.count {
            let a = numbers[n]
            let b = numbers[m]
            if a + b == 2020 {
                return a * b
            }
        }
    }
    return 0
}

public func findTriples(in numbers: [Int]) -> Int {
    for n in 0..<numbers.count {
        for m in (n+1)..<numbers.count {
            for j in (m+1)..<numbers.count {
                let a = numbers[n]
                let b = numbers[m]
                let c = numbers[j]
                if a + b + c == 2020 {
                    return a * b * c
                }
            }
        }
    }
    return 0
}
