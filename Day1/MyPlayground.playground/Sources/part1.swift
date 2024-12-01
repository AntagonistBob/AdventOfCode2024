public func part1() {
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

    let answer = zip(list1Sorted, list2Sorted).reduce(0, { $0 + abs($1.0 - $1.1) })
    print("Part 1 answer: \(answer)")
}

public let input = INPUT
