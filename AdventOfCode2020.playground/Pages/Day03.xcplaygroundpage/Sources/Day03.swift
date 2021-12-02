import Foundation


public enum Space {
    case Snow
    case Tree
    case End
}

public struct Slope {
    public var area : [[Space]]
    
    public init(pattern: String) {
        area = [[Space]]()
        for line in pattern.split(whereSeparator: \.isNewline) {
            area.append([Space]())
            for space in line {
                area[area.count-1].append(space == "." ? .Snow : .Tree)
            }
        }
    }
    
    public func at(x: Int, y: Int) -> Space {
        if y >= area.count {
            return .End
        }
        let xp = x % (area.first!.count)
        return area[y][xp]
    }
}

public struct Sled {
    public let rise: Int
    public let run: Int
    
    public init(rise: Int, run: Int) {
        self.rise = rise
        self.run = run
    }
    
    public func slideDown(slope: Slope) -> [Space] {
        var trip = [Space]()
        var x = 0
        var y = 0
        while slope.at(x: x, y: y) != .End {
            trip.append(slope.at(x: x, y: y))
            x = x + run
            y = y + rise
        }
        return trip
    }
}
