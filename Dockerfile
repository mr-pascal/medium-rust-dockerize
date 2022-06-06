################
##### Builder
FROM rust:1.61.0-slim as builder

WORKDIR /usr/src

# Create blank project
RUN USER=root cargo new medium-rust-dockerize

# We want dependencies cached, so copy those first.
COPY Cargo.toml Cargo.lock /usr/src/medium-rust-dockerize/

# Set the working directory
WORKDIR /usr/src/medium-rust-dockerize

## Install target platform (Cross-Compilation) --> Needed for Alpine
RUN rustup target add x86_64-unknown-linux-musl

# This is a dummy build to get the dependencies cached.
RUN cargo build --target x86_64-unknown-linux-musl --release

# Now copy in the rest of the sources
COPY src /usr/src/medium-rust-dockerize/src/

## Touch main.rs to prevent cached release build
RUN touch /usr/src/medium-rust-dockerize/src/main.rs

# This is the actual application build.
RUN cargo build --target x86_64-unknown-linux-musl --release

################
##### Runtime
FROM alpine:3.16.0 AS runtime 

# Copy application binary from builder image
COPY --from=builder /usr/src/medium-rust-dockerize/target/x86_64-unknown-linux-musl/release/medium-rust-dockerize /usr/local/bin

EXPOSE 3030

# Run the application
CMD ["/usr/local/bin/medium-rust-dockerize"]



