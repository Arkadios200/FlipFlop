extension Sequence {
  func tupleWindows() -> [(Element, Element)] {
    return Array(zip(self, self.dropFirst()))
  }

  func count(cond: (Element) -> Bool) -> Int {
    return self.filter(cond).count
  }
}

func getInput() -> [String] {
  var out: [String] = []
  while let line = readLine() { out.append(line) }

  return out
}

let leaves = [ "o-|": "L", "  |-o": "R" ]

func part1(_ stalk: [String], _ cut: Int = 400) -> Int {
  return stalk.dropLast(cut + 1)
    .count { $0.contains("o") }
}

func part2(_ stalk: [String]) -> Int {

  return stalk.compactMap { leaves[$0] }
    .tupleWindows()
    .count { $0.0 != $0.1 }
}

func part3(_ stalk: [String]) -> Int {
  var sides = stalk.compactMap { leaves[$0] }

  var i = 0
  while !sides.isEmpty {
    i += 1
    sides = sides.tupleWindows().compactMap {
      $0.0 == $0.1 ? $0.0 : nil
    }
  }

  return i
}

let stalk = getInput()

print("Part 1 answer:", part1(stalk))
print("Part 2 answer:", part2(stalk))
print("Part 3 answer:", part3(stalk))