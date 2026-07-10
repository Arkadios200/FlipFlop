enum Direction: Character {
  case up    = "^"
  case right = ">"
  case down  = "v"
  case left  = "<"

  func right() -> Direction {
    switch self {
      case .up:    return Direction.right
      case .right: return Direction.down
      case .down:  return Direction.left
      case .left:  return Direction.up
    }
  }
}

struct Point: Equatable, Hashable {
  var x, y: Int

  mutating func step(dir: Direction) {
    switch dir {
      case .up:    y -= 1
      case .right: x += 1
      case .down:  y += 1
      case .left:  x -= 1
    }
  }

  static let origin: Point = Point(x: 0, y: 0)
}

func getInput() -> [[Direction]] {
  var grid: [[Direction]] = []
  while let line = readLine() {
    grid.append(line.map { Direction(rawValue: $0)! })
  }

  return grid
}

func part1(_ grid: [[Direction]]) -> Int {
  var record: Set<Point> = []
  var pos = Point.origin
  while record.insert(pos).inserted {
    pos.step(dir: grid[pos.y][pos.x])
  }

  return record.count
}

func part2(_ grid: [[Direction]]) -> Int {
  var grid = grid

  var ans = 0
  for i in grid.indices.dropFirst().dropLast() {
    for j in grid.first!.indices.dropFirst().dropLast() {
      let temp = grid[i][j]
      for dir in [Direction.up, .right, .down, .left] {
        grid[i][j] = dir
        let score = part1(grid)
        if ans < score { ans = score }
      }

      grid[i][j] = temp
    }
  }

  return ans
}

func part3(_ grid: [[Direction]]) -> Int {
  var grid = grid
  let xRange = grid.first!.indices.dropFirst().dropLast()
  let yRange = grid.indices.dropFirst().dropLast()

  var ans = 0
  for i in yRange {
    for j in xRange {
      let temp = grid[i][j]
      for dir in [Direction.up, .right, .down, .left] {
        grid[i][j] = dir

        var record: Set<Point> = [Point.origin]
        var pos = Point.origin
        var illegalTurns = 0
        var skip = false
        while true {
          if !skip {
            pos.step(dir: grid[pos.y][pos.x])
          } else {
            skip = false
          }

          if !record.insert(pos).inserted {
            if illegalTurns < 3 && xRange.contains(pos.x) && yRange.contains(pos.y) {
              illegalTurns += 1
              pos.step(dir: grid[pos.y][pos.x].right())
              skip = true
            } else { break }
          }
        }

        if ans < record.count { ans = record.count }
      }

      grid[i][j] = temp
    }
  }

  return ans
}

let grid: [[Direction]] = getInput()

print(part1(grid))
print(part2(grid))
print(part3(grid))