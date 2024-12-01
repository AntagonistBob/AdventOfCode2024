public func part2() {
    let array = INPUT.split(separator: .init("\n"))

    var list1: [Int] = []
    var list2: [Int] = []

    for e in array {
        let temp = e.split(separator: "   ")
        list1.append(Int(temp[0]) ?? 0)
        list2.append(Int(temp[1]) ?? 0)
    }

    let list1Sorted = list1.sorted()
    let list2Sorted = list2.sorted()
    let dict = distinctCountDict(array: list2Sorted)

    let answer = list1Sorted.reduce(0, { total, element in
        total + (element * (dict[element] ?? 0))
    })

    print("Part 2 answer: \(answer)")
}

// creates a dictionary with the key being the num and the value being the # of times
// it appears in the list.
func distinctCountDict(array: [Int]) -> [Int: Int] {
    var dict: [Int: Int] = [:]
    /// Complexity: O(n)
    for (index, element) in array.enumerated() {
        if dict[element] == nil {
            var nextIndex = index + 1
            var count = 1
            while nextIndex < array.count && array[nextIndex] == element {
                count += 1
                nextIndex += 1
            }
            dict[element] = count
        }
    }
    
    return dict
}
