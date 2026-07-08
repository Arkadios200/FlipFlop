use std::ops::{Sub, Mul};

fn main() {
  let input = std::fs::read_to_string("input.txt").unwrap();

  let coffees: Vec<i32> = input.lines()
    .map(|line| line.parse().unwrap())
    .collect();

  let ans1 = coffees.iter()
    .fold(0, |acc, &v|
      acc + if v < 60 {
        60 - v
      } else {
        0
      });
  println!("{ans1}");

  let ans2 = coffees.iter()
    .fold(0, |acc, &v|
      acc + if v < 60 {
        60 - v
      } else {
        v.sub(60).mul(5)
      });
  println!("{ans2}");

  
  let (actual, preferred) = coffees.split_at(coffees.len()/2);
  let ans3 = actual.iter().zip(preferred)
    .fold(0, |acc, (&a, &b)|
      acc + if a < b {
        b - a
      } else {
        a.sub(b).mul(5)
      });
  println!("{ans3}");
}