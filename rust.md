# Rust

<https://www.rust-lang.org/>

Safe, fast, portable.

## Rust vs Golang

| Feature              | Rust                                                                 | Go (Golang)                                                        |
|----------------------|----------------------------------------------------------------------|--------------------------------------------------------------------|
| **Performance**       | - Zero-cost abstractions  <br> - Fine-grained control over memory   | - Fast compile times <br> - Efficient concurrency model            |
| **Memory Safety**     | - Guaranteed at compile time <br> - Ownership system                | - Garbage collected <br> - Easier to write but less deterministic  |
| **Concurrency**       | - Fearless concurrency with threads and async <br> - No data races  | - Goroutines <br> - Channels for communication                    |
| **Tooling**           | - `cargo` for builds and package management <br> - `clippy`, `rustfmt` | - Built-in `go` tool <br> - `gofmt` for formatting                 |
| **Error Handling**    | - `Result` and `Option` types <br> - No exceptions                  | - Error values <br> - No exceptions                                |
| **Learning Curve**    | - Steep <br> - Advanced concepts like lifetimes and ownership        | - Gentle <br> - Simple syntax and semantics                        |
| **Ecosystem**         | - Growing crates.io ecosystem <br> - Strong focus on correctness     | - Mature standard library <br> - Widely used in cloud infrastructure |
| **Use Cases**         | - Systems programming <br> - WebAssembly <br> - CLI tools            | - Web servers <br> - DevOps tools <br> - Cloud-native apps         |
| **Compilation Time**  | - Slower due to optimization passes                                  | - Very fast                                                        |
| **Community**         | - Friendly and inclusive <br> - Strong emphasis on documentation     | - Large and pragmatic <br> - Backed by Google                     |
