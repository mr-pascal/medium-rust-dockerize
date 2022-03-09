#FROM rust:1.59.0-alpine3.15 as builder
FROM rust:1.59.0-slim as builder

WORKDIR /usr/src

# Create blank project
RUN USER=root cargo new medium-rust-dockerize

# We want dependencies cached, so copy those first.
COPY Cargo.toml Cargo.lock /usr/src/medium-rust-dockerize/

WORKDIR /usr/src/medium-rust-dockerize

# This is a dummy build to get the dependencies cached.
RUN cargo build --release

# Now copy in the rest of the sources
COPY src /usr/src/medium-rust-dockerize/src/

## Touch main.rs to prevent cached release build
RUN touch /usr/src/medium-rust-dockerize/src/main.rs

# This is the actual build.
RUN cargo build --release


#FROM alpine:3.15.0 AS runtime # Rust and alpine somehow don't go well together
FROM debian:bookworm-slim AS runtime

COPY --from=builder /usr/src/medium-rust-dockerize/target/release/medium-rust-dockerize /usr/local/bin

EXPOSE 3030
CMD ["/usr/local/bin/medium-rust-dockerize"]



