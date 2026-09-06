use std::cell::RefCell;
use std::collections::HashMap;
use std::io::{self, Write};
use std::rc::Rc;

// ---------------------------------------------------------------------------
// Values
// ---------------------------------------------------------------------------

#[derive(Clone, Debug)]
enum Value {
    Nil,
    Number(f64),
    Symbol(String),
    List(Vec<Value>),
    Builtin(fn(&[Value], &Env) -> Result<Value, String>),
    Lambda {
        params: Vec<String>,
        body: Vec<Value>,
        closure: Env,
    },
}

impl PartialEq for Value {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Value::Nil, Value::Nil) => true,
            (Value::Number(a), Value::Number(b)) => a == b,
            (Value::Symbol(a), Value::Symbol(b)) => a == b,
            (Value::List(a), Value::List(b)) => a == b,
            (Value::Builtin(a), Value::Builtin(b)) => std::ptr::fn_addr_eq(*a, *b),
            (
                Value::Lambda {
                    params: p1,
                    body: b1,
                    ..
                },
                Value::Lambda {
                    params: p2,
                    body: b2,
                    ..
                },
            ) => p1 == p2 && b1 == b2,
            _ => false,
        }
    }
}

impl Value {
    fn is_truthy(&self) -> bool {
        !matches!(self, Value::Nil)
    }
}

// ---------------------------------------------------------------------------
// Environment
// ---------------------------------------------------------------------------

#[derive(Clone, Debug)]
struct Env {
    bindings: Rc<RefCell<HashMap<String, Value>>>,
    parent: Option<Rc<Env>>,
}

impl Env {
    fn new() -> Self {
        Env {
            bindings: Rc::new(RefCell::new(HashMap::new())),
            parent: None,
        }
    }

    fn extend(parent: &Env) -> Self {
        Env {
            bindings: Rc::new(RefCell::new(HashMap::new())),
            parent: Some(Rc::new(parent.clone())),
        }
    }

    fn define(&self, name: &str, value: Value) {
        self.bindings.borrow_mut().insert(name.to_string(), value);
    }

    fn set(&self, name: &str, value: Value) -> Result<(), String> {
        if self.bindings.borrow().contains_key(name) {
            self.bindings.borrow_mut().insert(name.to_string(), value);
            return Ok(());
        }
        match &self.parent {
            Some(p) => p.set(name, value),
            None => Err(format!("unbound variable: {}", name)),
        }
    }

    fn get(&self, name: &str) -> Result<Value, String> {
        if let Some(v) = self.bindings.borrow().get(name) {
            return Ok(v.clone());
        }
        match &self.parent {
            Some(p) => p.get(name),
            None => Err(format!("unbound variable: {}", name)),
        }
    }
}

// ---------------------------------------------------------------------------
// Reader
// ---------------------------------------------------------------------------

fn read_expr(chars: &mut std::iter::Peekable<std::str::Chars>) -> Result<Value, String> {
    skip_ws(chars);
    match chars.peek() {
        None => Err("unexpected EOF".to_string()),
        Some('(') => {
            chars.next();
            let mut list = Vec::new();
            loop {
                skip_ws(chars);
                match chars.peek() {
                    Some(')') => {
                        chars.next();
                        break;
                    }
                    None => return Err("unmatched '('".to_string()),
                    _ => list.push(read_expr(chars)?),
                }
            }
            Ok(Value::List(list))
        }
        Some('\'') => {
            chars.next();
            Ok(Value::List(vec![
                Value::Symbol("quote".to_string()),
                read_expr(chars)?,
            ]))
        }
        Some(_) => read_atom(chars),
    }
}

fn read_atom(chars: &mut std::iter::Peekable<std::str::Chars>) -> Result<Value, String> {
    let mut s = String::new();
    while let Some(&c) = chars.peek() {
        if c.is_whitespace() || c == '(' || c == ')' {
            break;
        }
        s.push(c);
        chars.next();
    }
    if let Ok(n) = s.parse::<f64>() {
        Ok(Value::Number(n))
    } else {
        Ok(Value::Symbol(s))
    }
}

fn skip_ws(chars: &mut std::iter::Peekable<std::str::Chars>) {
    while let Some(&c) = chars.peek() {
        if c.is_whitespace() {
            chars.next();
        } else {
            break;
        }
    }
}

// ---------------------------------------------------------------------------
// Eval / Apply
// ---------------------------------------------------------------------------

fn eval(expr: &Value, env: &Env) -> Result<Value, String> {
    match expr {
        Value::Nil | Value::Number(_) => Ok(expr.clone()),
        Value::Symbol(s) => env.get(s),
        Value::List(list) => {
            if list.is_empty() {
                return Ok(Value::Nil);
            }
            match &list[0] {
                // Special forms
                Value::Symbol(s) if s == "quote" => {
                    if list.len() < 2 {
                        return Err("quote needs an argument".to_string());
                    }
                    Ok(list[1].clone())
                }
                Value::Symbol(s) if s == "if" => {
                    if list.len() < 4 {
                        return Err("if needs (if cond then else)".to_string());
                    }
                    let cond = eval(&list[1], env)?;
                    if cond.is_truthy() {
                        eval(&list[2], env)
                    } else {
                        eval(&list[3], env)
                    }
                }
                Value::Symbol(s) if s == "define" => {
                    if list.len() < 3 {
                        return Err("define needs (define name value)".to_string());
                    }
                    let name = match &list[1] {
                        Value::Symbol(n) => n.clone(),
                        _ => return Err("define needs a symbol".to_string()),
                    };
                    let val = eval(&list[2], env)?;
                    env.define(&name, val);
                    Ok(Value::Symbol(name))
                }
                Value::Symbol(s) if s == "set!" => {
                    if list.len() < 3 {
                        return Err("set! needs (set! name value)".to_string());
                    }
                    let name = match &list[1] {
                        Value::Symbol(n) => n.clone(),
                        _ => return Err("set! needs a symbol".to_string()),
                    };
                    let val = eval(&list[2], env)?;
                    env.set(&name, val)?;
                    Ok(Value::Nil)
                }
                Value::Symbol(s) if s == "lambda" => {
                    if list.len() < 3 {
                        return Err("lambda needs params and body".to_string());
                    }
                    let params = match &list[1] {
                        Value::List(ps) => ps
                            .iter()
                            .map(|p| match p {
                                Value::Symbol(n) => Ok(n.clone()),
                                _ => Err("lambda params must be symbols".to_string()),
                            })
                            .collect::<Result<Vec<_>, _>>()?,
                        _ => return Err("lambda needs a param list".to_string()),
                    };
                    let body = list[2..].to_vec();
                    Ok(Value::Lambda {
                        params,
                        body,
                        closure: env.clone(),
                    })
                }
                Value::Symbol(s) if s == "begin" => {
                    let mut last = Value::Nil;
                    for e in &list[1..] {
                        last = eval(e, env)?;
                    }
                    Ok(last)
                }
                // Function application
                _ => {
                    let f = eval(&list[0], env)?;
                    let args: Result<Vec<_>, _> = list[1..].iter().map(|a| eval(a, env)).collect();
                    apply(f, &args?, env)
                }
            }
        }
        other => Ok(other.clone()),
    }
}

fn apply(f: Value, args: &[Value], env: &Env) -> Result<Value, String> {
    match f {
        Value::Builtin(func) => func(args, env),
        Value::Lambda {
            params,
            body,
            closure,
        } => {
            if params.len() != args.len() {
                return Err(format!(
                    "arity mismatch: expected {}, got {}",
                    params.len(),
                    args.len()
                ));
            }
            let local = Env::extend(&closure);
            for (p, a) in params.iter().zip(args.iter()) {
                local.define(p, a.clone());
            }
            let mut last = Value::Nil;
            for expr in &body {
                last = eval(expr, &local)?;
            }
            Ok(last)
        }
        _ => Err(format!("not a function: {:?}", f)),
    }
}

// ---------------------------------------------------------------------------
// Built-ins
// ---------------------------------------------------------------------------

fn builtins() -> Env {
    let env = Env::new();

    env.define(
        "+",
        Value::Builtin(|args, _| {
            let mut sum = 0.0;
            for a in args {
                match a {
                    Value::Number(n) => sum += n,
                    _ => return Err("+ needs numbers".to_string()),
                }
            }
            Ok(Value::Number(sum))
        }),
    );

    env.define(
        "-",
        Value::Builtin(|args, _| {
            if args.is_empty() {
                return Err("- needs arguments".to_string());
            }
            match args[0] {
                Value::Number(n) => {
                    let mut res = n;
                    for a in &args[1..] {
                        match a {
                            Value::Number(m) => res -= m,
                            _ => return Err("- needs numbers".to_string()),
                        }
                    }
                    Ok(Value::Number(res))
                }
                _ => Err("- needs numbers".to_string()),
            }
        }),
    );

    env.define(
        "*",
        Value::Builtin(|args, _| {
            let mut prod = 1.0;
            for a in args {
                match a {
                    Value::Number(n) => prod *= n,
                    _ => return Err("* needs numbers".to_string()),
                }
            }
            Ok(Value::Number(prod))
        }),
    );

    env.define(
        "/",
        Value::Builtin(|args, _| {
            if args.is_empty() {
                return Err("/ needs arguments".to_string());
            }
            match args[0] {
                Value::Number(n) => {
                    let mut res = n;
                    for a in &args[1..] {
                        match a {
                            Value::Number(m) => res /= m,
                            _ => return Err("/ needs numbers".to_string()),
                        }
                    }
                    Ok(Value::Number(res))
                }
                _ => Err("/ needs numbers".to_string()),
            }
        }),
    );

    env.define(
        "<",
        Value::Builtin(|args, _| {
            if args.len() != 2 {
                return Err("< needs 2 args".to_string());
            }
            match (&args[0], &args[1]) {
                (Value::Number(a), Value::Number(b)) => Ok(if a < b {
                    Value::Symbol("t".to_string())
                } else {
                    Value::Nil
                }),
                _ => Err("< needs numbers".to_string()),
            }
        }),
    );

    env.define(
        "eq?",
        Value::Builtin(|args, _| {
            if args.len() != 2 {
                return Err("eq? needs 2 args".to_string());
            }
            Ok(if args[0] == args[1] {
                Value::Symbol("t".to_string())
            } else {
                Value::Nil
            })
        }),
    );

    env.define(
        "atom?",
        Value::Builtin(|args, _| {
            if args.len() != 1 {
                return Err("atom? needs 1 arg".to_string());
            }
            Ok(match args[0] {
                Value::List(_) => Value::Nil,
                _ => Value::Symbol("t".to_string()),
            })
        }),
    );

    env.define(
        "car",
        Value::Builtin(|args, _| {
            if args.len() != 1 {
                return Err("car needs 1 arg".to_string());
            }
            match &args[0] {
                Value::List(v) if !v.is_empty() => Ok(v[0].clone()),
                _ => Err("car needs a non-empty list".to_string()),
            }
        }),
    );

    env.define(
        "cdr",
        Value::Builtin(|args, _| {
            if args.len() != 1 {
                return Err("cdr needs 1 arg".to_string());
            }
            match &args[0] {
                Value::List(v) if !v.is_empty() => Ok(Value::List(v[1..].to_vec())),
                _ => Err("cdr needs a non-empty list".to_string()),
            }
        }),
    );

    env.define(
        "cons",
        Value::Builtin(|args, _| {
            if args.len() != 2 {
                return Err("cons needs 2 args".to_string());
            }
            let mut list = match &args[1] {
                Value::List(v) => v.clone(),
                other => vec![other.clone()],
            };
            list.insert(0, args[0].clone());
            Ok(Value::List(list))
        }),
    );

    env.define(
        "list",
        Value::Builtin(|args, _| Ok(Value::List(args.to_vec()))),
    );

    env.define(
        "print",
        Value::Builtin(|args, _| {
            for a in args {
                print_value(a);
                print!(" ");
            }
            println!();
            Ok(Value::Nil)
        }),
    );

    env
}

// ---------------------------------------------------------------------------
// Printer
// ---------------------------------------------------------------------------

fn print_value(v: &Value) {
    match v {
        Value::Nil => print!("()"),
        Value::Number(n) => {
            if n.fract() == 0.0 {
                print!("{:.0}", n);
            } else {
                print!("{}", n);
            }
        }
        Value::Symbol(s) => print!("{}", s),
        Value::List(l) => {
            print!("(");
            for (i, item) in l.iter().enumerate() {
                if i > 0 {
                    print!(" ");
                }
                print_value(item);
            }
            print!(")");
        }
        Value::Builtin(_) => print!("<builtin>"),
        Value::Lambda { .. } => print!("<lambda>"),
    }
}

// ---------------------------------------------------------------------------
// REPL
// ---------------------------------------------------------------------------

fn run_repl() -> Result<(), String> {
    println!("Rust Lisp — type (quit) to exit");
    let env = builtins();

    loop {
        print!("> ");
        io::stdout()
            .flush()
            .map_err(|e| format!("failed to flush stdout: {}", e))?;

        let mut line = String::new();
        if io::stdin()
            .read_line(&mut line)
            .map_err(|e| format!("failed to read line: {}", e))?
            == 0
        {
            break;
        }

        let line = line.trim();
        if line.is_empty() || line.starts_with(';') {
            continue;
        }

        let mut chars = line.chars().peekable();
        match read_expr(&mut chars) {
            Ok(expr) => {
                if let Value::List(l) = &expr {
                    if let Some(Value::Symbol(s)) = l.first() {
                        if s == "quit" {
                            break;
                        }
                    }
                }
                match eval(&expr, &env) {
                    Ok(v) => {
                        print_value(&v);
                        println!();
                    }
                    Err(e) => eprintln!("Error: {}", e),
                }
            }
            Err(e) => eprintln!("Read error: {}", e),
        }
    }

    Ok(())
}

fn main() {
    if let Err(e) = run_repl() {
        eprintln!("Fatal: {}", e);
        std::process::exit(1);
    }
}
