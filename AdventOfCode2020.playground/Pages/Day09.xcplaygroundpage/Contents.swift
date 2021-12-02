//: [Previous](@previous)

import Foundation

var exampleNumbers = [
    35,
    20,
    15,
    25,
    47,
    40,
    62,
    55,
    65,
    95,
    102,
    117,
    150,
    182,
    127,
    219,
    299,
    277,
    309,
    576
]



exampleNumbers
    .dropFirst(5)
    .prefix(5)


check(numbers: exampleNumbers, withWindow: 5)

var r = check(numbers: numbersFrom(file: "Day09"), withWindow: 25)
    .filter{!$0.2}
    .map{$0.1}
    .first ?? 0
r

var exampleRun = findSumRun(ofN: 127, overRange: exampleNumbers)
exampleRun.min()
exampleRun.max()

var run = findSumRun(ofN: r, overRange: numbersFrom(file: "Day09"))
if run.count > 0 {
    var _ =
        run.min()!
        + run.max()!
}
//: [Next](@next)
