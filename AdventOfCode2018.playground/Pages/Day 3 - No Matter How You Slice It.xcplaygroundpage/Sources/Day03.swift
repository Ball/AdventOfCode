import Foundation


let pattern = #"#(?<claimId>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)"#

public struct Claim {
    public let number: Int
    let area: CGRect
    
    public init(claim: String){
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let nsrange =  NSRange(claim.startIndex..<claim.endIndex, in: claim)
        let match = regex.firstMatch(in: claim, options: [], range: nsrange)!
        area = CGRect(x: Int(claim[Range(match.range(withName:"x"), in: claim)!])!,
                   y: Int(claim[Range(match.range(withName:"y"), in: claim)!])!,
                   width: Int(claim[Range(match.range(withName:"width"), in: claim)!])!,
                   height: Int(claim[Range(match.range(withName:"height"), in: claim)!])!)
        number = Int(claim[Range(match.range(withName: "claimId"), in: claim)!])!
    }
    
    public func intersects(with: Claim) -> Bool {
        return self.area.intersects(with.area)
    }
    public func intersection(with: Claim) -> CGRect {
        return self.area.intersection(with.area)
    }
}
