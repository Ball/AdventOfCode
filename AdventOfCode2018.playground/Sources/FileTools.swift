import Foundation

public func numbersFrom(file: String) -> [Int] {
    if let path = Bundle.main.path(forResource: file, ofType: "txt"),
       let data = FileManager.default.contents(atPath: path),
       let string = String(data: data, encoding: .utf8) {
        return string
            .split(whereSeparator: \.isNewline)
            .map({Int($0)!})
    }
    return []
}
public func linesFrom(file: String) -> [String] {
    if let path = Bundle.main.path(forResource: file, ofType: "txt"),
       let data = FileManager.default.contents(atPath: path),
       let string = String(data: data, encoding: .utf8) {
        return string
            .split(whereSeparator: \.isNewline)
            .map{String($0)}
    }
    return []
}
