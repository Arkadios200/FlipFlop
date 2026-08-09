import 'dart:io';
import 'dart:math';

void main() {
  final String input = File('input.txt').readAsStringSync();
  final (route, sushi) = process(input);

  print('Part 1 answer: ${part1(route, sushi)}');
  print('Part 2 answer: ${part2(route, sushi)}');
  print('Part 3 answer: ${part3(route, sushi)}');
}

int part1(List<Direction> route, List<Point> sushi) {
  Point snake = Point(0, 0);
  int i = 0;
  for (final Direction dir in route.sublist(0, route.length ~/ 2)) {
    snake.step(dir);
    if (snake == sushi[i]) i += 1;
  }

  return i;
}

int part2(List<Direction> route, List<Point> sushi) {
  List<Point> snake = [Point(0, 0)];
  int i = 0;
  for (final Direction dir in route) {
    snake.insert(0, snake.first.next(dir));
    if (snake.first == sushi[i]) i += 1;
    else snake.removeLast();

    if (snake.sublist(1).contains(snake.first)) return snake.length;
  }

  // Unreachable with valid inputs
  exit(1);
}

int part3(List<Direction> route, List<Point> sushi) {
  List<Point> snake = [Point(0, 0)];
  int i = 0;
  int ateSelf = 0;
  for (final Direction dir in route) {
    snake.insert(0, snake.first.next(dir));
    if (i < sushi.length && snake.first == sushi[i]) i += 1;
    else snake.removeLast();

    int index = snake.lastIndexOf(snake.first);
    if (index > 0) {
      snake.removeAfter(index - 1);
      ateSelf += 1;
    }
  }

  return snake.length * ateSelf;
}

(List<Direction>, List<Point>) process(String input) {
  final List<String> lines = input.lines().toList();

  final List<Direction> route = lines[0]
    .split('')
    .map(Direction.fromString)
    .toList();

  List<Point> sushi = [];
  for (final String line in lines.sublist(1)) {
    if (line.isEmpty) continue;

    final (a, b) = line.splitOnce(',')!;
    sushi.add(Point(int.parse(a), int.parse(b)));
  }

  return (route, sushi);
}

extension on List {
  void removeAfter(int start) {
    this.removeRange(start, this.length);
  }
}

extension on String {
  Iterable<String> lines() =>
    this.split('\n');

  (String, String)? splitOnce(String delimiter) {
    int i = this.indexOf(delimiter);
    if (i == null) return null;

    return (this.substring(0, i), this.substring(i+1));
  }
}

class Point {
  int x, y;

  Point(this.x, this.y);
  Point.clone(Point p) : this(p.x, p.y);

  Point next(Direction dir) =>
    this + switch (dir) {
      Direction.up    => Point( 0,  1),
      Direction.right => Point( 1,  0),
      Direction.down  => Point( 0, -1),
      Direction.left  => Point(-1,  0),
    };

  void step(Direction dir) {
    Point next = this.next(dir);

    this.x = next.x;
    this.y = next.y;
  }

  @override
  bool operator==(Object other) =>
    other is Point
    && this.x == other.x
    && this.y == other.y;

  @override
  int get hashCode =>
    Object.hash(x, y);

  Point operator+(Point other) =>
    Point(this.x + other.x, this.y + other.y);
}

enum Direction {
  up, right, down, left;

  static Direction fromString(String s) =>
    switch (s) {
      '^' => up,
      '>' => right,
      'v' => down,
      '<' => left,
      _ => exit(1),
    };
}