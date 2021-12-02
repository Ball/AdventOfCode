import Foundation

public struct Point : Hashable {
    public let x:Int
    public let y:Int
    
    public var distance :Int {
        get {
            return abs(x) + abs(y)
        }
    }
}

public struct Wire {
    public var trail : Set<Point> = Set()
    public var path : [Point] = [Point]()
    
    public init(path: String) {
        var x = 0
        var y = 0
        for cmd in path.split(separator: ","){
            let toTravel = Int(cmd.dropFirst())!
            switch String(cmd.first!) {
            case "R":
                for _ in 0..<toTravel {
                    x = x + 1
                    trail.insert(Point(x: x, y: y))
                    self.path.append(Point(x: x, y: y))
                }
                break
            case "D":
                for _ in 0..<toTravel {
                    y = y+1
                    trail.insert(Point(x: x, y: y))
                    self.path.append(Point(x: x, y: y))
                }
                break
            case "L":
                for _ in 0..<toTravel {
                    x = x - 1
                    trail.insert(Point(x: x, y: y))
                    self.path.append(Point(x: x, y: y))
                }
                break
            case "U":
                for _ in 0..<toTravel {
                    y = y - 1
                    trail.insert(Point(x: x, y: y))
                    self.path.append(Point(x: x, y: y))
                }
                break
            default:
                break
            }
        }
    }
    public func intersections(with: Wire) -> [Point] {
        return trail.intersection(with.trail).map{$0}
    }
    public func distanceToIntersection(with: Wire) -> Int {
        let intersections =
                trail.intersection(with.trail).map{$0}
        
        return 2 + (intersections.map({(intersection) in
            return path.prefix(while: {$0 != intersection}).count + with.path.prefix(while: {$0 != intersection}).count
        })
        .min() ?? 0)
    }
}
