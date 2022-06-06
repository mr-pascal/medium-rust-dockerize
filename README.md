
# medium-rust-dockerize


```sh
# Build local
cargo build

# Run local
cargo run 
```

```sh

# Build container
docker build -t rust-web-alpine .

# Run container
docker run --rm -p 3030:3030 --name server rust-web-alpine


```


