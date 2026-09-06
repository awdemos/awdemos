# lisp/

A minimal Lisp interpreter in Rust with a REPL — a single-file, zero-dependency demonstration of the classic read-eval-print loop architecture.

## Features

- **Reader**: s-expression parser with `quote` shorthand (`'(a b)` → `(quote (a b))`)
- **Special forms**: `quote`, `if`, `define`, `set!`, `lambda`, `begin`
- **Built-ins**: `+`, `-`, `*`, `/`, `<`, `eq?`, `atom?`, `car`, `cdr`, `cons`, `list`, `print`
- **Lexical closures**: lambdas capture their defining environment
- **Recursion**: named functions can call themselves (`fact`, `fib`)
- **Shared state**: closures mutate captured bindings via `set!`
- **REPL**: type `(quit)` or press Ctrl-D to exit; `;` starts a comment line

## Run

```bash
cargo run --release
```

## Example session

```lisp
Rust Lisp — type (quit) to exit
> (+ 1 2 3)
6
> (define square (lambda (x) (* x x)))
square
> (square 7)
49
> (define make-adder (lambda (n) (lambda (x) (+ x n))))
make-adder
> ((make-adder 5) 3)
8
> (cons 1 '(2 3))
(1 2 3)
```

## Architecture

```
┌─────────┐     ┌──────────┐     ┌───────┐     ┌──────────┐
│  Reader │────▶│  Value   │────▶│ Eval  │────▶│ Printer  │
│ (parse) │     │ (AST)    │     │+ Apply│     │ (output) │
└─────────┘     └──────────┘     └───┬───┘     └──────────┘
                                     │
                              ┌──────▼─────────────┐
                              │    Env             │
                              │ (Rc<RefCell<map>> + │
                              │ Rc parent ptr)     │
                              └────────────────────┘
```

- `Value` — the AST and runtime value type in one (numbers, symbols, lists, builtins, lambdas)
- `Env` — chained hash maps with interior mutability (`Rc<RefCell<...>>`); `define`/`set!` mutate through shared references, `set!` walks up the parent chain
- Closures share their defining environment, so recursion and mutable captured state work

## License

MIT (see [LICENSE](../../../LICENSE))
