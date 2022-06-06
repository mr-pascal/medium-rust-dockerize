use warp::{Filter};


#[tokio::main]
async fn main() {
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));

    let routes =
        warp::
        get()
            .and(hello);

    let (host , port) = ([0,0,0,0], 3030);

    println!("Starting server on: {}:{}", host.map(|a| a.to_string()).join("."), port);
    warp::serve(routes)
        .run((host, port))
        .await;

}