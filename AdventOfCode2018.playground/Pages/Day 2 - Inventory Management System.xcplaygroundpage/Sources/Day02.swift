import Foundation


public func check(box:String) -> (Int,Int) {
    var m = [Character:Int]()
    for c in box {
        m[c] = (m[c] ?? 0) + 1
    }
    let twos = m.values.filter({$0 == 2}).isEmpty ? 0 : 1
    let threes = m.values.filter({$0 == 3}).isEmpty ? 0 : 1
    return (twos, threes)
}

public func distance(box1:String, box2: String) -> Int {
    return zip(box1.enumerated(), box2.enumerated()).filter({$0 != $1}).count
}
