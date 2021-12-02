import Foundation

public class Computer {
    public var program:[Int]
    var iptr = 0
    
    public init(program: [Int] ){
        self.program = program
    }
    
    public func indirectRead(at: Int) -> Int {
        read(at: read(at: at))
    }
    
    public func indirectWrite(value: Int, at: Int) {
        write(value: value, at: read(at: at))
    }
    
    public func read(at: Int) -> Int {
        program[at]
    }
    
    public func write(value: Int, at: Int) {
        program[at] = value
    }
    public func run() {
        while(step()){
            
        }
    }
    public func step() -> Bool {
        switch program[iptr] {
        case 1:
            let a = indirectRead(at: iptr + 1)
            let b = indirectRead(at: iptr + 2)
            indirectWrite(value: a + b, at: iptr + 3)
//            program[program[iptr + 3]] = program[program[iptr + 1]] + program[program[iptr + 2]]
            iptr = iptr + 4
            break
        case 2:
            let a = indirectRead(at: iptr + 1)
            let b = indirectRead(at: iptr + 2)
            indirectWrite(value: a * b, at: iptr + 3)
//            program[program[iptr + 3]] = program[program[iptr + 1]] * program[program[iptr + 2]]
            iptr = iptr + 4
            break
        case 99:
            return false
        default:
            return false
        }
        return true
    }
}
