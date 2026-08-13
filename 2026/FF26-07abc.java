import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    Pair<List<Direction>, List<Point>> input = getInput();
    List<Direction> route = input.a;
    List<Point> sushi     = input.b;

    System.out.printf("Part 1 answer: %d\n", part1(route, sushi));
    System.out.printf("Part 2 answer: %d\n", part2(route, sushi));
    System.out.printf("Part 3 answer: %d\n", part3(route, sushi));
  }

  static int part1(List<Direction> route, List<Point> sushi) {
    Point snake = new Point(0, 0);

    int i = 0;
    for (Direction dir : route.subList(0, route.size()/2)) {
      snake.step(dir);
      if (snake.equals(sushi.get(i))) i += 1;
    }

    return i;
  }

  static int part2(List<Direction> route, List<Point> sushi) {
    List<Point> snake = new ArrayList<>();
    snake.add(new Point(0, 0));

    int i = 0;
    for (Direction dir : route) {
      snake.add(0, snake.get(0).next(dir));

      if (snake.get(0).equals(sushi.get(i))) i += 1;
      else snake.remove(snake.size() - 1);

      if (snake.subList(1, snake.size()).contains(snake.get(0))) return snake.size();
    }

    throw new RuntimeException();
  }

  static int part3(List<Direction> route, List<Point> sushi) {
    List<Point> snake = new ArrayList<>();
    snake.add(new Point(0, 0));

    int ateSelf = 0;
    int i = 0;
    for (Direction dir : route) {
      snake.add(0, snake.get(0).next(dir));

      if (i < sushi.size() && snake.get(0).equals(sushi.get(i))) i += 1;
      else snake.remove(snake.size() - 1);

      int index = snake.lastIndexOf(snake.get(0));
      if (index > 0) {
        snake = snake.subList(0, index-1);
        ateSelf += 1;
      }
    }

    return snake.size() * ateSelf;
  }

  static Pair<List<Direction>, List<Point>> getInput() {
    Scanner sc = new Scanner(System.in);

    String line = sc.nextLine();
    List<Direction> route = new ArrayList<>();
    for (char c : line.toCharArray()) {
      route.add(Direction.fromChar(c));
    }

    List<Point> sushi = new ArrayList<>();
    while (sc.hasNextLine()) {
      line = sc.nextLine();
      if (line.length() == 0) continue;

      String[] temp = line.split(",");
      sushi.add(new Point(Integer.parseInt(temp[0]), Integer.parseInt(temp[1])));
    }

    return new Pair<>(route, sushi);
  }
}

class Point {
  int x, y;

  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public Point(Point p) {
    this.x = p.x;
    this.y = p.y;
  }

  public Point next(Direction dir) {
    return this.add(Point.fromDirection(dir));
  }

  public void step(Direction dir) {
    Point n = this.next(dir);
    this.x = n.x;
    this.y = n.y;
  }

  public static Point fromDirection(Direction dir) {
    switch (dir) {
    case UP:
      return new Point( 0,  1);
    case RIGHT:
      return new Point( 1,  0);
    case DOWN:
      return new Point( 0, -1);
    case LEFT:
      return new Point(-1,  0);
    default:
      throw new RuntimeException();
    }
  }

  public Point add(Point other) {
    return new Point(this.x + other.x, this.y + other.y);
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Point)) return false;

    Point other = (Point) o;
    return this.x == other.x && this.y == other.y;
  }
}

enum Direction {
  UP,
  RIGHT,
  DOWN,
  LEFT;

  public static Direction fromChar(char c) {
    switch (c) {
    case '^':
      return Direction.UP;
    case '>':
      return Direction.RIGHT;
    case 'v':
      return Direction.DOWN;
    case '<':
      return Direction.LEFT;
    default:
      throw new RuntimeException();
    }
  }
}

class Pair<A, B> {
  final A a;
  final B b;

  public Pair(A a, B b) {
    this.a = a;
    this.b = b;
  }
}