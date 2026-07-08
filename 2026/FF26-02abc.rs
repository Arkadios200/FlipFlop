use std::ops::{Add, Mul, Neg};

fn main() {
  let input = std::fs::read_to_string("input.txt").unwrap();

  let route: Vec<Direction> = input.chars().map(Direction::from).collect();

  println!("Part 1 answer: {}", part1(&route));
  println!("Part 2 answer: {}", part2(&route));
  println!("Part 3 answer: {}", part3(&route));
}

fn part1(route: &[Direction]) -> usize {
  let mut tiles: [usize; 100] = [0; 100];
  let mut robot = Robot::new();
  for dir in route {
    robot.step(dir);
    tiles[robot.pos as usize] += 1;
  }

  let (i, temp) = tiles.iter()
    .enumerate().rev()
    .max_by_key(|(_, &temp)| temp)
    .unwrap();

  i.add(1).mul(temp)
}

fn part2(route: &[Direction]) -> usize {
  let mut robot = Robot::new();
  let mut tile  = Robot::new();

  let mut out: usize = 0;
  for (r, t) in route.iter().zip(route.iter().rev()) {
    robot.step(r);
    tile.step(t);
    if robot.pos == tile.pos { out += 1; }
  }

  out
}

fn part3(route: &[Direction]) -> usize {
  let mut tiles: [usize; 100] = [0; 100];
  let mut robot = Robot::new();
  for (r, t) in route.iter().zip(route.iter().rev()) {
    robot.step(r);
    robot.step(&-t);
    tiles[robot.pos as usize] += 1;
  }

  let (i, temp) = tiles.iter()
    .enumerate().rev()
    .max_by_key(|(_, &temp)| temp)
    .unwrap();

  i.add(1).mul(temp)
}

#[derive(Clone, Copy)]
struct Robot {
  pos: isize,
}

impl Robot {
  fn new() -> Self {
    Self { pos: 0 }
  }

  fn step(&mut self, dir: &Direction) {
    self.pos = self.pos.add(match dir {
      Direction::Left  => -1,
      Direction::Right =>  1,
    }).rem_euclid(100);
  }
}

#[derive(Clone, Copy)]
enum Direction {
  Left,
  Right,
}

impl Neg for Direction {
  type Output = Self;
  fn neg(self) -> Self {
    match self {
      Direction::Left  => Direction::Right,
      Direction::Right => Direction::Left,
    }
  }
}

impl Neg for &Direction {
  type Output = Direction;
  fn neg(self) -> Direction {
    -*self
  }
}

impl From<char> for Direction {
  fn from(c: char) -> Self {
    match c {
      '<' => Direction::Left,
      '>' => Direction::Right,
      _ => panic!(),
    }
  }
}