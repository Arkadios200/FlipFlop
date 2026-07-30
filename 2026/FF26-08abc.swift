func main() {
  let lines: [[String]] = getInput()

  print("Part 1 answer:", part1(lines))
  print("Part 2 answer:", part2(lines))
  print("Part 3 answer:", part3(lines))
}

func part1(_ lines: [[String]]) -> Int {
  var rules: [String: [String]] = [:]
  for line in lines {
    if rules[line.first!] == nil { rules[line.first!] = Array(line.dropFirst()) }
  }

  var stoats: [String: Int] = ["A": 1, "B": 1]
  for _ in 1...7 {
    var next: [String: Int] = [:]
    for (k, v) in stoats {
      for s in rules[k]! { next[s, default: 0] += v }
    }

    stoats = next
  }

  return stoats.values.reduce(0, +)
}

func part2(_ lines: [[String]]) -> Int {
  var rules: [[String]: [String]] = [:]
  for line in lines {
    let key1 = [line[0], line[1]]
    let val1 = [key1.first!] + line.dropFirst(2)
    rules[key1] = val1

    if line[0] == line[1] { continue }

    let key2 = [line[1], line[0]]
    let val2 = [key2.first!] + line.dropFirst(2)
    rules[key2] = val2
  }

  var stoats: [String] = ["A", "B"]
  for _ in 1...7 {
    stoats = stoats.windows(of: 2).map { rules[Array($0)]! }.joined() + [stoats.last!]
  }

  return stoats.count
}

func part3(_ lines: [[String]]) -> Int {
  var rules: [[String]: [String]] = [:]
  for line in lines {
    let key1 = [line[0], line[1]]
    let val1 = [key1.first!] + line.dropFirst(2) + [key1.last!]
    rules[key1] = val1

    if line[0] == line[1] { continue }

    let key2 = [line[1], line[0]]
    let val2 = [key2.first!] + line.dropFirst(2) + [key2.last!]
    rules[key2] = val2
  }

  var stoats: [[String]: Int] = [["A", "B"]: 1]
  for _ in 1...21 {
    var next: [[String]: Int] = [:]
    for (k, v) in stoats {
      for w in rules[k]!.windows(of: 2) {
        next[Array(w), default: 0] += v
      }
    }

    stoats = next
  }

  return stoats.values.reduce(1, +)
}

func getInput() -> [[String]] {
  var lines: [[String]] = []
  while let line = readLine() {
    lines.append(line.split(separator: " ").map { String($0) })
  }

  return lines
}

extension Array {
  func windows(of size: Int) -> [SubSequence] {
    return self.indices.dropLast(size-1).map { self[$0..<$0+size] }
  }
}

main()