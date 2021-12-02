import Foundation

public func neverDecreases(_ number : Int) -> Bool {
    var last = 0
    for n in String(number).map({Int(String($0))!}) {
        if last > n {
            return false
        }
        last = n
    }
    return true
}
public func hasMultiples(_ number: Int) -> Bool {
    let digits : [String] = String(number).enumerated().map({String($0.element)})

    return 0 <
        (zip(digits, digits.dropFirst())
        .filter{ (a,b) in return a == b}
        .count)
}
func hasDouble(digits: [String]) -> Bool {
    let first = digits.first
    if first == nil {
        return false
    }
    if 2 == digits.prefix(while: {$0 == first}).count {
        return true
    } else {
        return hasDouble(digits: digits.drop(while: {$0 == first}).map{$0})
    }
}
public func validatesDoubles(_ number: Int) -> Bool {
    let digits : [String] = String(number).enumerated().map({String($0.element)})
    return hasDouble(digits: digits)
//    var hasDouble = false
//    var hasTripple = false
//    for i in 0..<(digits.count-1) {
//        hasDouble = hasDouble || digits[i] == digits[i+1]
//        if(i < digits.count-2 && digits[i] == digits[i+2]){
//            hasTripple = true
//        }
//    }
//    return hasDouble && !hasTripple
}
