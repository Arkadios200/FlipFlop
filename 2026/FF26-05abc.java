import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;
import java.util.Objects;

public class Main {
  public static void main(String[] args) {
    List<List<Direction>> grid = getInput();

    System.out.printf("Part 1 answer: %d\n", part1(grid));
    System.out.printf("Part 2 answer: %d\n", part2(grid));
    System.out.printf("Part 3 answer: %d\n", part3(grid));
  }

  static int part1(List<List<Direction>> grid) {
    Point pos = new Point(0, 0);
    Set<Point> record = new HashSet<>();

    while (record.add(new Point(pos))) {
      pos.step(pos.findIn(grid));
    }

    return record.size();
  }

  static int part2(List<List<Direction>> grid) {
    int ans = 0;
    for (int i = 1; i < grid.size() - 2; i++) {
      for (int j = 1; j < grid.get(i).size() - 2; j++) {
        Direction temp = grid.get(i).get(j);
        for (Direction dir : new Direction[] { Direction.UP, Direction.RIGHT, Direction.DOWN, Direction.LEFT }) {
          grid.get(i).set(j, dir);
          int score = part1(grid);
          if (ans < score) ans = score;
        }

        grid.get(i).set(j, temp);
      }
    }

    return ans;
  }

  static int part3(List<List<Direction>> grid) {
    int ans = 0;
    for (int i = 1; i < grid.size() - 2; i++) {
      for (int j = 1; j < grid.get(i).size() - 2; j++) {
        Direction temp = grid.get(i).get(j);
        for (Direction dir : new Direction[] { Direction.UP, Direction.RIGHT, Direction.DOWN, Direction.LEFT }) {
          grid.get(i).set(j, dir);

          Point pos = new Point(0, 0);
          Set<Point> record = new HashSet<>();
          record.add(new Point(pos));

          int illegalTurns = 0;
          boolean skip = false;
          while (true) {
            if (!skip) {
              pos.step(pos.findIn(grid));
            } else skip = false;

            if (!record.add(new Point(pos))) {
              if (illegalTurns < 3
              && pos.x > 0
              && pos.x < grid.get(0).size() - 1 
              && pos.y > 0
              && pos.y < grid.size() - 1) {
                illegalTurns += 1;
                pos.step(pos.findIn(grid).right());
                skip = true;
              } else break;
            }
          }

          if (ans < record.size()) ans = record.size();
        }

        grid.get(i).set(j, temp);
      }
    }

    return ans;
  }

  static List<List<Direction>> getInput() {
    List<List<Direction>> grid = new ArrayList<>();
    Scanner sc = new Scanner(System.in);
    while (sc.hasNextLine()) {
      List<Direction> row = new ArrayList<>();
      for (char c : sc.nextLine().toCharArray()) {
        row.add(Direction.fromChar(c));
      }

      grid.add(row);
    }

    sc.close();

    return grid;
  }
}

class Point {
  int x, y;

  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public Point(Point p) {
    this(p.x, p.y);
  }

  public Point next(Direction dir) {
    return this.add(dir.toPoint());
  }

  public void step(Direction dir) {
    Point nextPoint = this.next(dir);

    this.x = nextPoint.x;
    this.y = nextPoint.y;
  }

  public Point add(Point other) {
    return new Point(this.x + other.x, this.y + other.y);
  }

  public <T> T findIn(List<List<T>> grid) {
    return grid.get(y).get(x);
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Point)) return false;

    Point other = (Point) o;
    return this.x == other.x && this.y == other.y;
  }

  @Override
  public int hashCode() {
    return Objects.hash(x, y);
  }
}

enum Direction {
  UP,
  RIGHT,
  DOWN,
  LEFT;

  public Direction right() {
    switch (this) {
    case UP:
      return RIGHT;
    case RIGHT:
      return DOWN;
    case DOWN:
      return LEFT;
    case LEFT:
      return UP;
    default:
      throw new RuntimeException();
    }
  }

  public Point toPoint() {
    switch (this) {
    case UP:
      return new Point(0, -1);
    case RIGHT:
      return new Point(1, 0);
    case DOWN:
      return new Point(0, 1);
    case LEFT:
      return new Point(-1, 0);
    default:
      throw new RuntimeException();
    }
  }

  static Direction fromChar(char c) {
    switch (c) {
    case '^':
      return UP;
    case '>':
      return RIGHT;
    case 'v':
      return DOWN;
    case '<':
      return LEFT;
    default:
      throw new RuntimeException();
    }
  }
}