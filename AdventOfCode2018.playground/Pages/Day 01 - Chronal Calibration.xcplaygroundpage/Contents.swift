import Cocoa

func runFrequencies(on: Int, deltas: [Int]) -> Int {
    deltas
        .reduce(on){$0 + $1}
}

func commansToNumbers(string: String) -> [Int] {
    return string.split(separator: Character(","))
        .map{Int($0.trimmingCharacters(in: .whitespacesAndNewlines))!}
}

runFrequencies(on: 0, deltas: commansToNumbers(string:  "+1, +1, +1"))
runFrequencies(on: 0, deltas: commansToNumbers(string:  "+1, +1, -2"))
runFrequencies(on: 0, deltas: commansToNumbers(string: "-1, -2, -3"))

runFrequencies(on: 0, deltas: numbersFrom(file:"Day01"))

func findDuplicate(on: Int, deltas: [Int]) -> Int {
    var seen = Set<Int>()
    var f = on
    var i = 0
    while(!seen.contains(f)){
        seen.insert(f)
        if i >= deltas.count {
            i = 0
        }
        f = f + deltas[i]
        i = i + 1
    }
    return f
}

findDuplicate(on: 0, deltas: numbersFrom(file: "Day01"))
