//: [Previous](@previous)

import Foundation

// Pattern:
//    BagType : String + " " + String + " bag" + "s"?
//    BagContents : Int + " " + BagType
//    ContentsList : BagContents + ", " + ContentsList | BagContents + "."
//    Rule : BagType + " contains " + (ContentsList | "contain no other bags.")

let ExampleRule = "light red bags contain 1 bright white bag, 2 muted yellow bags."

var words = [String]()

ExampleRule.enumerateSubstrings(in: ExampleRule.startIndex..<ExampleRule.endIndex, options: .byWords, { (substring, _, _ , _) -> () in
    words.append(substring ?? "unknown")
})

struct Contents {
    let number: Int
    let name: String
}
struct Rule {
    let name : String
    var contains : [Contents]
    
    func canContain(bag: String, accordingTo rules: [String:Rule]) -> Bool {
        if contains.isEmpty {
            return false
        }
        if contains.contains(where: {$0.name == bag}) {
            return true
        }
        return contains.filter{ rules[$0.name]?.canContain(bag: bag, accordingTo: rules) ?? false }.count > 0
    }
    func mustContain(accordingTo rules: [String: Rule]) -> Int {
        if contains.isEmpty { return 0 }
        return contains.map { $0.number + $0.number * rules[$0.name]!.mustContain(accordingTo: rules) }
            .reduce(0){ $0 + $1}
    }
    
    init(text: String) {
        var words = [String]()
        contains = [Contents]()
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords, {(token, _,_,_) in
            words.append(token!)
        })
        name = "\(words[0]) \(words[1])"
        words.removeFirst(2)
        words.remove(at: 0) // bags
        if words.joined(separator: " ") == "contain no other bags" {
            return
        }
        words.removeFirst(1) // contains
        
        while !words.isEmpty {
            contains.append(Contents(number: Int(words[0])!, name: "\(words[1]) \(words[2])"))
            
            words.removeFirst(4)
        }
    }
}

var rule = Rule(text: ExampleRule)
rule.name
rule.contains

var rules =
    linesFrom(file:"Day07").map { Rule(text: $0)}
var ruleBook = [String:Rule]()
var seen = Set<String>()
for rule in rules {
    ruleBook[rule.name] = rule
}

rules
    .filter { $0.canContain(bag: "shiny gold", accordingTo: ruleBook)}
    .count


var shortRules  = [
    "shiny gold bags contain 2 dark red bags.",
    "dark red bags contain 2 dark orange bags.",
    "dark orange bags contain 2 dark yellow bags.",
    "dark yellow bags contain 2 dark green bags.",
    "dark green bags contain 2 dark blue bags.",
    "dark blue bags contain 2 dark violet bags.",
    "dark violet bags contain no other bags."]
    .map{ Rule(text: $0)}
var shortRuleBook = [String: Rule]()
for rule in shortRules {
    shortRuleBook[rule.name] = rule
}

shortRuleBook["dark violet"]!.mustContain(accordingTo: shortRuleBook)
shortRuleBook["shiny gold"]!.mustContain(accordingTo: shortRuleBook) // 126

ruleBook["shiny gold"]!.mustContain(accordingTo: ruleBook)
//: [Next](@next)
