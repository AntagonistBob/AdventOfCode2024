
// sorry peeps but I had no energy tonight so I didn't bother cleaning up my code
nonisolated(unsafe) var constraints: [String: [String]] = [:]

public func part1() {
    
    let inputArray = input1String.split(separator: "\n")
    inputArray.forEach {
        let keyAndValue = $0.split(separator: "|")
        let key = String(keyAndValue[0])
        let value = String(keyAndValue[1])

        if var values = constraints[key] {
            values.append(value)
            constraints[key] = values
        } else {
            constraints[key] = [value]
        }
    }
    
    let pageOrderRequests = input2String.split(separator: "\n")
    
    var count = 0
    for request in pageOrderRequests {
        
        let pageNumbers = request.split(separator: ",").reversed().map { String($0) }
        var isValid = true
        print("Page order: \(pageNumbers)")

        for (index, pageNumber) in pageNumbers.enumerated() {

            if let constraint = constraints[pageNumber] {
                print("Constraints for \(pageNumber): \(constraint)")
                // look at upcoming page numbers and fail if ANY of them are in the
                // constraints list
                for upcomingPageNumberIndex in index+1..<pageNumbers.count {
                    if constraint.contains(pageNumbers[upcomingPageNumberIndex]) {
                        print("INVALID!")
                        isValid = false
                        break
                    }
                }
                
            } else {
                continue
            }
        }
        
        if isValid {
            print("This one is valid: \(pageNumbers)")
            let middle = pageNumbers[(pageNumbers.count - 1) / 2]
            count += Int(middle) ?? 0
        }
    }
    
    print("Part 1 answer: \(count)")
}

public func part2() {
    let inputArray = input1String.split(separator: "\n")
    inputArray.forEach {
        let keyAndValue = $0.split(separator: "|")
        let key = String(keyAndValue[0])
        let value = String(keyAndValue[1])

        if var values = constraints[key] {
            values.append(value)
            constraints[key] = values
        } else {
            constraints[key] = [value]
        }
    }
    
    let pageOrderRequests = input2String.split(separator: "\n")
    
    var invalids: Set<[String]> = .init([])
    for request in pageOrderRequests {
        
        let pageNumbers = request.split(separator: ",").reversed().map { String($0) }
        var isValid = true
        print("Page order: \(pageNumbers)")

        for (index, pageNumber) in pageNumbers.enumerated() {

            if let constraint = constraints[pageNumber] {
                print("Constraints for \(pageNumber): \(constraint)")
                // look at upcoming page numbers and fail if ANY of them are in the
                // constraints list
                for upcomingPageNumberIndex in index+1..<pageNumbers.count {
                    if constraint.contains(pageNumbers[upcomingPageNumberIndex]) {
                        print("INVALID!")
                        isValid = false
                        break
                    }
                }
                
            } else {
                continue
            }
        }
        
        if !isValid {
            invalids.insert(pageNumbers)
        }
    }
    
    var count = 0

    // fix them with switching
    for brokenList in invalids {
        var switchingList = brokenList
        var firstInvalidIndex = calcFirstInvalidIndex(in: switchingList)

        while firstInvalidIndex != nil {
            switchingList.swapAt(firstInvalidIndex!.0, firstInvalidIndex!.1)
            firstInvalidIndex = calcFirstInvalidIndex(in: switchingList)
        }

        print("before: \(brokenList)")
        print("after: \(switchingList)")
        // success
        let middle = switchingList[(switchingList.count - 1) / 2]
        count += Int(middle) ?? 0
    }
    
    
    print("Part 2 answer: \(count)")
}

func calcFirstInvalidIndex(in set: [String]) -> (Int, Int)? {
    print("Checking first invalid index for \(set)")
    for (index, pageNumber) in set.enumerated() {
        if let constraint = constraints[pageNumber] {
            // look at upcoming page numbers and fail if ANY of them are in the
            // constraints list
            for upcomingPageNumberIndex in index+1..<set.count {
                if constraint.contains(set[upcomingPageNumberIndex]) {
                    return (index, upcomingPageNumberIndex)
                }
            }
        }
    }
    
    return nil
}
