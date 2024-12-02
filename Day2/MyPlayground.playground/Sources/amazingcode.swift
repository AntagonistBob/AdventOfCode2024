
public func run() {
    // part 1
    let records = inputString.split(separator: .init("\n")).map { String($0) }
    part1(records: records)
    part2(records: records) // its not correct; I gave up
}

public func part1(records: [String]) {
    let answer = records.filter({ record in
        let levels = record.split(separator: " ").compactMap { Int($0) }
        
        guard levels.count >= 2
        else { return true } // segment with length of 1 is valid
        
        let firstNum = levels[0]
        let secondNum = levels[1]
        
        guard firstNum != secondNum
        else { return false }
        
        let isAscending = secondNum > firstNum
        
        for index in 1..<levels.count {
            let currentNum = levels[index]
            let previousNum = levels[index - 1]
            let difference = abs(currentNum - previousNum)

            if isAscending {
                guard currentNum > previousNum && difference > 0 && difference < 4
                else { return false}
            } else {
                guard previousNum > currentNum && difference > 0 && difference < 4
                else { return false}
            }
        }
        
        return true
    }).count
    
    print("Part 1 answer: \(answer)") // answer is 502
}

public func part2(records: [String]) {
    let invalidRecords = invalidRecords(records: records)
    let answer = invalidRecords.filter({ record in
        let levels = record.split(separator: " ").compactMap { Int($0) }
        
        // edge cases
        
        // length of < 1 is always valid
        if levels.count <= 1 {
            return true
        }

        // length of 2 is always valid because one level can be removed
        if levels.count == 2 {
            return true
        }
        
        // length of 3 with 1 invalid level, what should be removed?
        if levels.count == 3 {
            let firstNum = levels[0]
            let secondNum = levels[1]
            let thirdNum = levels[2]
            
            // check all configurations
            if firstNum != secondNum && abs(firstNum - secondNum) < 4 {
                return true
            } else if secondNum != thirdNum && abs(secondNum - thirdNum) < 4 {
                return true
            } else if firstNum != thirdNum && abs(firstNum - thirdNum) < 4 {
                return true
            } else {
                return false
            }
        }
        
        var firstViolation: Bool = false

        let difference = abs(levels[1] - levels[0])
        if difference == 0 || difference > 4 {
            firstViolation = true
        }

        for index in 2..<levels.count {
            let difference = abs(levels[index] - levels[index - 1])
            if difference == 0 || difference > 4 {
                if firstViolation {
                    return false
                } else {
                    firstViolation = true
                }
            }
        }
        
        return true
    }).count
    
    print("Part 2 answer: \(answer + 502)") // answer is 502
}

// nice part1 copy-paste with all returns inverted
private func invalidRecords(records: [String]) -> [String] {
    return records.filter({ record in
        let levels = record.split(separator: " ").compactMap { Int($0) }
        
        guard levels.count >= 2
        else { return false } // segment with length of 1 is valid
        
        let firstNum = levels[0]
        let secondNum = levels[1]
        
        guard firstNum != secondNum
        else { return true }
        
        let isAscending = secondNum > firstNum
        
        for index in 1..<levels.count {
            let currentNum = levels[index]
            let previousNum = levels[index - 1]
            let difference = abs(currentNum - previousNum)

            if isAscending {
                guard currentNum > previousNum && difference > 0 && difference < 4
                else { return true}
            } else {
                guard previousNum > currentNum && difference > 0 && difference < 4
                else { return true}
            }
        }

        return false
    })
}
