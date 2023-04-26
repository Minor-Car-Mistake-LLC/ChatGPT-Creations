use rand::Rng;
use std::collections::VecDeque;
use std::time::Duration;
use std::{thread, time};
use termion::input::TermRead;
use termion::raw::IntoRawMode;
use termion::{clear, color, cursor};

#[derive(Clone, Copy, PartialEq)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

struct Snake {
    body: VecDeque<(u16, u16)>,
    direction: Direction,
}

struct Food {
    x: u16,
    y: u16,
}

fn main() {
    let (width, height) = (20, 10);
    let mut snake = Snake {
        body: VecDeque::from(vec![(5, 5), (4, 5), (3, 5)]),
        direction: Direction::Right,
    };
    let mut food = Food { x: 10, y: 5 };
    let mut score = 0;
    let mut rng = rand::thread_rng();
    let stdin = std::io::stdin();
    let mut stdout = std::io::stdout().into_raw_mode().unwrap();
    write!(stdout, "{}", clear::All).unwrap();
    loop {
        write!(stdout, "{}", cursor::Goto(1, 1)).unwrap();
        for y in 1..=height {
            for x in 1..=width {
                if snake.body.contains(&(x, y)) {
                    write!(stdout, "{}{}█{}", color::Fg(color::Green), color::Bg(color::Black), color::Fg(color::Reset)).unwrap();
                } else if (x, y) == (food.x, food.y) {
                    write!(stdout, "{}{}${}", color::Fg(color::Red), color::Bg(color::Black), color::Fg(color::Reset)).unwrap();
                } else {
                    write!(stdout, " ").unwrap();
                }
            }
            write!(stdout, "\r\n").unwrap();
        }
        thread::sleep(time::Duration::from_millis(100));
        let input = stdin.keys().next().unwrap().unwrap();
        let next_direction = match input {
            termion::event::Key::Char('q') => break,
            termion::event::Key::Up => Direction::Up,
            termion::event::Key::Down => Direction::Down,
            termion::event::Key::Left => Direction::Left,
            termion::event::Key::Right => Direction::Right,
            _ => snake.direction,
        };
        snake.direction = next_direction;
        let (head_x, head_y) = snake.body.front().unwrap().clone();
        let new_head = match next_direction {
            Direction::Up => (head_x, head_y - 1),
            Direction::Down => (head_x, head_y + 1),
            Direction::Left => (head_x - 1, head_y),
            Direction::Right => (head_x + 1, head_y),
        };
        if new_head == (food.x, food.y) {
            food.x = rng.gen_range(1, width + 1);
            food.y = rng.gen_range(1, height + 1);
            score += 1;
        } else {
            snake.body.pop_back();
        }
        if new_head.0 <= 0 || new_head.0 > width || new_head.1 <= 0 || new_head.1 > height || snake.body.contains(&new_head) {
            write!(stdout, "{}", clear::All).unwrap();
            write!(stdout
                , "{}GAME OVER! Score: {}", cursor::Goto(1, height + 2), score).unwrap();
                break;
                }
                snake.body.push_front(new_head);
                }
                }