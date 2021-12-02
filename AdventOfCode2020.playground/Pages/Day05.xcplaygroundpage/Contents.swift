//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

class BoardingPass {
    var row : Int = 0
    var column : Int = 0
    var seatID : Int {
        get {
            return row * 8 + column
        }
    }
    init(code: String){
        for c in code {
            switch c {
            case "B":
                row  = row << 1
                row = row | 1
                break
            case "F":
                row = row << 1
                break
            case "L":
                column = column << 1
            case "R":
                column = column << 1
                column = column | 1
                break
            default:
                break
            }
        }
    }
}

var pass1 = BoardingPass(code: "BFFFBBFRRR")
pass1.row
pass1.column
pass1.seatID
var pass2 = BoardingPass(code: "FFFBBBFRRR")
pass2.row
pass2.column
pass2.seatID
var pass3 = BoardingPass(code: "BBFFBBFRLL")
pass3.row
pass3.column
pass3.seatID

var passes:[BoardingPass] = linesFrom(file:"Day05").map { BoardingPass(code: $0)}
var sorted = passes.sorted(by: {$0.seatID > $1.seatID})
var highest = sorted.first
highest?.seatID
var nexts = sorted.dropFirst()
let passId = zip(sorted, nexts)
    .first(where: {(a,b) in (a.seatID - b.seatID) > 1 })!.0
passId.seatID - 1

//: [Next](@next)
