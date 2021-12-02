//: [Previous](@previous)

import Foundation


check(box: "abced")
check(box: "bababc")
check(box: "abbcde")
check(box: "abbcbde")

let c = linesFrom(file: "Day02")
    .map{check(box: $0)}
    .reduce((0,0)){(a,b) in (a.0 + b.0, a.1 + b.1)}
c.0 * c.1

func shared(box1:String, box2: String) -> String {
    return String(zip(box1.enumerated(), box2.enumerated()).filter({$0 == $1}).map{$0.0.element})
}
func findPairs( boxes: [String]) -> [String] {
    for i in 0..<boxes.count {
        for j in i..<boxes.count {
            if(distance(box1: boxes[i], box2: boxes[j]) == 1){
                return [i,j].map{boxes[$0]}
            }
        }
    }
    return []
}
let two = distance(box1: "abcde", box2: "axcye")
let one = distance(box1: "fghij", box2: "fguij")
let pairs = findPairs(boxes: linesFrom(file:"Day02"))
let s = shared(box1: pairs[0], box2: pairs[1])
"pebjqsalrdnckzfihvtxysomg" == s
//: [Next](@next)
