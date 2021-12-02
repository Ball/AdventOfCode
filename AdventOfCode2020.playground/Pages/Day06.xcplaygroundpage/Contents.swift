//: [Previous](@previous)

class Group{
    var claims: Set<Character> = Set<Character>()
    var totalClaims : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz")
    
    func make(claim: String) {
        totalClaims = totalClaims.intersection(Set(claim))
        for c in claim {
            claims.insert(c)
        }
    }
}

var groups = [Group]()
groups.append(Group())

for line in  stringFrom(file:"Day06").components(separatedBy: .newlines){
    if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        groups.append(Group())
    } else {
        groups.last?.make(claim: line)
    }
}

groups
    .map{$0.claims.count}
    .reduce(Int(0), {$0 + $1})

groups
    .dropLast()
    .map{$0.totalClaims.count}
    .reduce(0, {$0 + $1})


//: [Next](@next)
