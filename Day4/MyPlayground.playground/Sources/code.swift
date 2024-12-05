enum XMAS: Character {
    case X = "X"
    case M = "M"
    case A = "A"
    case S = "S"
    
    var next: XMAS? {
        switch self {
            case .X:
                .M
            case .M:
                .A
            case .A:
                .S
            case .S:
                nil
        }
    }
}

public func part1() {
    let table = inputString.split(separator: "\n").map { Array(String($0)) }
    var answerCount = 0
    
    let rowLength = table.count
    for rowIndex in 0..<rowLength {
        let columnLength = table[rowIndex].count
        
        for columnIndex in 0..<columnLength {
            
            func charAt(row: Int, column: Int) -> Character? {
                guard row >= 0 && row < rowLength && column >= 0 && column < columnLength
                else { return nil }

                return table[row][column]
            }
            
            func scanForM(rowIndex: Int, columnIndex: Int) {
                for rowSearchIndex in rowIndex-1...rowIndex+1 {
                    for columnSearchIndex in columnIndex-1...columnIndex+1 {
                        
                        if rowSearchIndex == rowIndex && columnSearchIndex == columnIndex {
                            continue // slight optimization to break out
                        }
                        
                        if charAt(row: rowSearchIndex, column: columnSearchIndex) == XMAS.M.rawValue {
                            // Found M! now calculate direction.
                            let dx = rowSearchIndex - rowIndex
                            let dy = columnSearchIndex - columnIndex
                            
                            if charAt(row:rowSearchIndex + dx, column: columnSearchIndex + dy) == XMAS.A.rawValue &&
                                charAt(row:rowSearchIndex + 2*dx, column: columnSearchIndex + 2*dy) == XMAS.S.rawValue
                            {
                                answerCount += 1
                            } else {
                                continue
                            }
                                
                        }
                        
                    }
                }
            }
            
            if table[rowIndex][columnIndex] == XMAS.X.rawValue {
                scanForM(rowIndex: rowIndex, columnIndex: columnIndex)
            }
        }
    }
    
    print("Part 1 answer: \(answerCount)") // answer: 2557
}

public func part2() {
    let table = inputString.split(separator: "\n").map { Array(String($0)) }
    var answerCount = 0
    
    let rowLength = table.count
    for rowIndex in 0..<rowLength {
        let columnLength = table[rowIndex].count
        
        for columnIndex in 0..<columnLength {
            
            func charAt(row: Int, column: Int) -> Character? {
                guard row >= 0 && row < rowLength && column >= 0 && column < columnLength
                else { return nil }

                return table[row][column]
            }
            
            func scanForX(rowIndex: Int, columnIndex: Int) {
                guard
                let topLeft = charAt(row: rowIndex-1, column: columnIndex-1),
                topLeft != "X", topLeft != "A",
                let topRight = charAt(row: rowIndex-1, column: columnIndex+1),
                topRight != "X", topRight != "A",
                let bottomLeft = charAt(row: rowIndex+1, column: columnIndex-1),
                bottomLeft != "X", bottomLeft != "A",
                else {
                    return
                }

                // diagonals can't be the same
                if topLeft == bottomRight {
                    return
                } else if topRight == bottomLeft {
                    return
                }

                // all preconditions pass so this must be a valid X
                answerCount += 1
            }
            
            if table[rowIndex][columnIndex] == XMAS.A.rawValue {
                scanForX(rowIndex: rowIndex, columnIndex: columnIndex)
            }
        }
    }
    
    print("Part 2 answer: \(answerCount)") // answer: 1854
}

// failed because it ignored DIRECTION, so for example
// AM
// SX
// was counted as one answer. I'm keeping this in the hopes that its useful for part 2.
// .... it wasn't
public func part1FirstFailedAttempt() {
    let table = inputString.split(separator: "\n").map { Array(String($0)) }
    var answerCount = 0
    
    let rowLength = table.count
    for rowIndex in 0..<rowLength {
        let columnLength = table[rowIndex].count
        
        for columnIndex in 0..<columnLength {
            
            func boundsCheck(row: Int, column: Int) -> Character? {
                guard row >= 0 && row < rowLength && column >= 0 && column < columnLength
                else { return nil }

                return table[row][column]
            }
            
            func recursiveCount(rowIndex: Int, columnIndex: Int, lookingFor value: XMAS) {
                for rowSearchIndex in rowIndex-1...rowIndex+1 {
                    for columnSearchIndex in columnIndex-1...columnIndex+1 {
                        
                        if rowSearchIndex == rowIndex && columnSearchIndex == columnIndex {
                            continue // slight optimization to break out
                        }
                        
                        if boundsCheck(row: rowSearchIndex, column: columnSearchIndex) == value.rawValue {
                            // Found the char we were search for! check whether its the end or not
                            if let nextValue = value.next {
                                recursiveCount(rowIndex: rowSearchIndex, columnIndex: columnSearchIndex, lookingFor: nextValue)
                            } else {
                                print("Found it!")
                               answerCount += 1 // reached the end so we count
                            }
                        }
                        
                    }
                }
            }
            
            if table[rowIndex][columnIndex] == "X" {
                recursiveCount(rowIndex: rowIndex, columnIndex: columnIndex, lookingFor: .M)
            }
        }
    }
    
    print("Part 1 answer: \(answerCount)") // answer: 38191
}


