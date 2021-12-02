import Foundation


public struct PasswordCheck {
    static let pattern = #"(?<min>\d+)-(?<max>\d+) (?<req>[^:]): (?<password>.*)"#
    public let policy: PasswordPolicy
    public let password: Substring
    public var isValid: Bool { get { policy.check(password: String(self.password) ) } }
    public var isSecondaryValid: Bool { get { policy.checkSecondary(password: String(self.password))}}
    
    public init(_ string: String) {
        let regex = try! NSRegularExpression(pattern: PasswordCheck.pattern, options:[])
        let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)
        let match = regex.firstMatch(in: string, options:[], range: nsrange)!
        let min = Int(string[Range(match.range(withName: "min"), in: string)!])!
        let max = Int(string[Range(match.range(withName: "max"), in: string)!])!
        let req = string[Range(match.range(withName: "req"), in:string)!]
        password = string[Range(match.range(withName: "password"), in:string)!]
        policy = PasswordPolicy(substring: req, min: min, max: max)
    }
    
}

public struct PasswordPolicy {
    public let substring: Substring
    public let min: Int
    public let max: Int
    
    public func check(password:String) -> Bool {
        let count = password.components(separatedBy: substring).count - 1
        return count >= min && count <= max
    }
    public func checkSecondary(password: String) -> Bool {
        let a = password.dropFirst(min-1).starts(with: String(substring))
        let b = password.dropFirst(max-1).starts(with: String(substring))
        return (a || b) && (a != b)
    }
}
