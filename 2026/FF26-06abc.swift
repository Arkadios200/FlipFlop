extension Array {
  func get(at index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

enum Direction: Character {
  case up    = "^"
  case right = ">"
  case down  = "v"
  case left  = "<"
}

struct Point: Equatable, Hashable {
  var x, y: Int

  func next(_ dir: Direction) -> Point {
    return self + {
      switch dir {
        case .up:    return Point(x:  0, y: +1)
        case .right: return Point(x: +1, y:  0)
        case .down:  return Point(x:  0, y: -1)
        case .left:  return Point(x: -1, y:  0)
      }
    }()
  }

  mutating func step(_ dir: Direction) {
    self = self.next(dir)
  }

  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static let origin: Point = Point(x: 0, y: 0)
}

func getInput() -> ([Direction], [Point]) {
  let route = readLine()!.map { Direction(rawValue: $0)! }

  var sushi: [Point] = []
  while let line = readLine() {
    if line.isEmpty { continue }

    let coords = line.split(separator: ",").map { Int($0)! }
    sushi.append(Point(x: coords[0], y: coords[1]))
  }

  return (route, sushi)
}

func part1(_ route: [Direction], _ sushi: [Point]) -> Int {
  var snake = Point.origin
  var i = 0
  for dir in route.prefix(route.count / 2) {
    snake.step(dir)
    if snake == sushi[i] { i += 1 }
  }

  return i
}

func part2(_ route: [Direction], _ sushi: [Point]) -> Int {
  var snake: [Point] = [Point.origin]
  var i = 0
  for dir in route {
    snake.insert(snake.first!.next(dir), at: 0)
    if snake.first! == sushi[i] { i += 1 }
    else { snake.removeLast() }

    if snake.dropFirst().contains(snake.first!) { break }
  }

  return snake.count
}

func part3(_ route: [Direction], _ sushi: [Point]) -> Int {
  var snake: [Point] = [Point.origin]
  var i = 0
  var ateSelf = 0
  for dir in route {
    snake.insert(snake.first!.next(dir), at: 0)
    if let s = sushi.get(at: i), snake.first! == s { i += 1 }
    else { snake.removeLast() }

    if let seg = snake.dropFirst().firstIndex(of: snake.first!) {
      snake = Array(snake.prefix(seg-1))
      ateSelf += 1
    }
  }

  return ateSelf * snake.count
}

let (route, sushi) = getInput()

print("Part 1 answer:", part1(route, sushi))
print("Part 2 answer:", part2(route, sushi))
print("Part 3 answer:", part3(route, sushi))
