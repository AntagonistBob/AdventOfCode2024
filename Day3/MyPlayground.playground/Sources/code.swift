public func part1() {
    let regex = /mul\((\d+),(\d+)\)/
    let matches = inputString.matches(of: regex)
    
    var total = 0
    for match in matches {
        if let int1 = Int(match.output.1), let int2 = Int(match.output.2) {
            total += (int1 * int2)
        }
    }
    
    print("Answer 1: \(total)")
}

public func part2() {
    let regex = /mul\((\d+),(\d+)\)|don't\(\)|do\(\)/
    let matches = inputString.matches(of: regex)
    
    var total = 0
    var dont = false // do is reserved keyword :(
    for match in matches {
        if match.output.0.contains("don't()") {
            dont = true
        } else if match.output.0.contains("do()") {
            dont = false
        }
        
        if !dont,
           let string1 = match.output.1, let int1 = Int(string1),
           let string2 = match.output.2, let int2 = Int(string2)
        {
            total += (int1 * int2)
        }
    }
    
    print("Answer 2: \(total)")
}

