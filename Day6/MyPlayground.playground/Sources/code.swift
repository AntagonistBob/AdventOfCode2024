import Foundation

class Guard {
    
    var x: Int
    var y: Int
    var facing: Direction
    
    init(x: Int, y: Int, facing: Direction) {
        self.x = x
        self.y = y
        self.facing = facing
    }
    
    func turn() {
        switch facing {
            case .up:
                self.facing = .right
            case .down:
                self.facing = .left
            case .left:
                self.facing = .up
            case .right:
                self.facing = .down
        }
    }
    
    var delta: (Int, Int) {
        switch guardd.facing { // can probably put this logic in Guard
            case .up:
                return (0, -1)
            case .down:
                return (0, 1)
            case .left:
                return (-1, 0)
            case .right:
                return (1, 0)
        }
    }
    
    var deltaForRightTurn: (Int, Int) {
        switch guardd.facing {
        case .up:
            return (1, 0)
        case .down:
            return (-1, 0)
        case .left:
            return (0, 1)
        case .right:
            return (0, -1)
        }
    }
    
    var symbol: String {
        switch guardd.facing {
            case .up:
                "U"
            case .down:
                "D"
            case .left:
                "L"
            case .right:
                "R"
        }
    }
    
    var nextSymbol: String {
        if symbol == "U" {
            return "R"
        } else if symbol == "D" {
            return "L"
        } else if symbol == "R" {
            return "D"
        } else if symbol == "L" {
            return "U"
        }
        
        return "P" // this will never happen
    }
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
}

nonisolated(unsafe) var map: [[String]] = []
nonisolated(unsafe) var guardd: Guard = .init(x: 0, y: 0, facing: .up)

public func setup() {
    let inputRows = testString.split(separator: "\n")
    for (y, row) in inputRows.enumerated() {
        if let xIndex = row.firstIndex(where: { $0 == "^" }) {
            let x = row.distance(from: row.startIndex, to: xIndex)
            guardd = .init(x: x, y: y, facing: .up)
        }
        
        map.append(row.map {
            $0 == "^" ? String("U") : String($0) // replace guard start with X
        })
        
    }
    print("Guard: (\(guardd.x), \(guardd.y))")
    printMap(map)
}

public func part1() {
    setup()
    var count = 1
    var reachedTheEnd = false
    repeat {
        let (dx, dy) = guardd.delta
        guard canMove(x: guardd.x + dx, y: guardd.y + dy)
        else {
            reachedTheEnd = true
            break
        }

        let nextSquare = map[guardd.y + dy][guardd.x + dx]
        if nextSquare == "#" {
            guardd.turn()
        } else if nextSquare == "." {
            count += 1
            map[guardd.y + dy][guardd.x + dx] = "X"
            guardd.x += dx
            guardd.y += dy
        } else if nextSquare == "X" {
            guardd.x += dx
            guardd.y += dy
        }
    } while !reachedTheEnd
    
//    printMap(map)
    print("Part 1 answer: \(count)")
}

public func part2() {
    setup()
    var count = 0
    var reachedTheEnd = false
    repeat {
        let (dx, dy) = guardd.delta
        guard canMove(x: guardd.x + dx, y: guardd.y + dy)
        else {
            reachedTheEnd = true
            break
        }

        let nextSquare = map[guardd.y + dy][guardd.x + dx]
        if nextSquare == "#" {
            guardd.turn()
        } else {
            // check right path
            let (rightDx, rightDy) = guardd.deltaForRightTurn
            var tempPosition: (Int, Int) = (guardd.x, guardd.y)
            while (true) {
                guard
                    canMove(x: tempPosition.0 + rightDx, y: tempPosition.1 + rightDy),
                    map[tempPosition.0 + rightDx][tempPosition.1 + rightDy] != "#"
                else { break }
                
                if map[tempPosition.0 + rightDx][tempPosition.1 + rightDy].contains(guardd.nextSymbol) {
                    if map[guardd.x + dx][guardd.y + dy] == "." {
                        map[guardd.x + dx][guardd.y + dy] = "O"
                    } else {
                        map[guardd.x + dx][guardd.y + dy].append("O")
                    }
                    count += 1
                    break
//                    printMap(map)
//                    return
                }
                tempPosition = (tempPosition.0 + rightDx, tempPosition.1 + rightDy)
            }
            
            // do normal guard movement
            if nextSquare == "." {
                map[guardd.y + dy][guardd.x + dx] = guardd.symbol
            } else {
                
                map[guardd.y + dy][guardd.x + dx] = map[guardd.y + dy][guardd.x + dx].appending(guardd.symbol)
            }
            guardd.x += dx
            guardd.y += dy
        }
        
    } while !reachedTheEnd
    
    printMap(map)
    print("Part 1 answer: \(count)")
}

func canMove(x: Int, y: Int) -> Bool {
    x >= 0 && x < map[0].count && y >= 0 && y < map.count
}

func printMap(_ map: [[String]]) {
    print("******************************")
    for row in map {
        print(row.reduce(into: "", { str, char in str.append("   \(char)") }))
    }
    print("******************************")
}


// attempt 1 FAIL (this doesn't work because it can't count 'distinct' moves
// only total moves)
/*
 
 struct Obstacle {
     let x: Int
     let y: Int
 }

 struct Line {
     var obstacles: [Obstacle]
     
     mutating func add(obstacle: Obstacle) {
         obstacles.append(obstacle)
     }
 }
 
 public func part1() {
     let inputRows = testString.split(separator: "\n")
     var rows: [Line] = []
     var columns: [Line] = []
     var guardd: Guard = .init(x: 0, y: 0, facing: .up)

     for i in 0..<inputRows[0].count {
         columns.append(.init(obstacles: []))
     }

     for (y, row) in inputRows.enumerated() {
         if let x = row.firstIndex(of: "^") {
             let xDis = row.distance(from: row.startIndex, to: x)
             guardd = .init(x: xDis, y: y, facing: .up)
             print("Found guard at x: \(xDis), y: \(y)")
         }

         let obstacles = row.ranges(of: "#")
             .map {
                 let xDis = row.distance(from: row.startIndex, to: $0.lowerBound)
                 return Obstacle.init(x: xDis, y: y)
             }

         rows.append(.init(obstacles: obstacles))

         // add all these obstacles to their relevant column array
         for obstacle in obstacles {
 //            print("Inserting \(obstacle) into columns...")
             columns[obstacle.x].add(obstacle: obstacle)
         }
     }
     
     print("Rows:")
     rows.forEach {
         print($0)
     }
     
     print("Columns:")
     columns.forEach {
         print($0)
     }
     
     var count = 1 // count guards starting location
     var reachedEnd = false
     repeat {
         switch guardd.facing {
         case .right:
             let obs = rows[guardd.x].obstacles
             if let nextObstacle = obs.first(where: { $0.x > guardd.x }) {
                 count += abs(nextObstacle.x - guardd.x)
                 guardd.x = nextObstacle.x - 1
                 guardd.turn()
             } else {
                 reachedEnd = true
             }
         case .left:
             let obs = rows[guardd.x].obstacles
             if let nextObstacle = obs.first(where: { $0.x < guardd.x }) {
                 count += abs(nextObstacle.x - guardd.x)
                 guardd.x = nextObstacle.x + 1
                 guardd.turn()
             } else {
                 reachedEnd = true
             }
         case .up:
             let obs = columns[guardd.x].obstacles
             if let nextObstacle = obs.first(where: { $0.y < guardd.y }) {
                 count += abs(nextObstacle.y - guardd.y)
                 guardd.y = nextObstacle.y + 1
                 guardd.turn()
             } else {
                 reachedEnd = true
             }
         case .down:
             let obs = columns[guardd.x].obstacles
             if let nextObstacle = obs.first(where: { $0.y > guardd.y }) {
                 count += abs(nextObstacle.y - guardd.y)
                 guardd.y = nextObstacle.y - 1
                 guardd.turn()
             } else {
                 reachedEnd = true
             }
         }
         
     } while !reachedEnd
     
     print("Part 1 answer: \(count)")
 }
 */
