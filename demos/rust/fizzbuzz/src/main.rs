fn fizz_buzz(n: i32) -> String {
    match (n % 3 == 0, n % 5 == 0) {
        (true, true) => "FizzBuzz".to_string(),
        (true, false) => "Fizz".to_string(),
        (false, true) => "Buzz".to_string(),
        (false, false) => n.to_string(),
    }
}

fn main() {
    for i in 1..=100 {
        println!("{}", fizz_buzz(i));
    }
}

