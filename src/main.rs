use warp::{Filter, post};
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
struct Employee {
    name: String,
    rate: u32,
}


#[tokio::main]
async fn main() {
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));

    // POST /employees/:rate  {"name":"Sean","rate":2}
    let promote = warp::post()
        .and(warp::path("employees"))
        .and(warp::path::param::<u32>())
        // Only accept bodies smaller than 16kb...
        .and(warp::body::content_length_limit(1024 * 16))
        .and(warp::body::json())
        .map(|rate, mut employee: Employee| {
            // adds the rate from the request to the current one
            employee.rate = rate + employee.rate;
            // Return a JSON object
            warp::reply::json(&employee)
        });

    let routes =
        warp::
        get()
            .and(hello)
        .or(
            post()
                .and(
                    promote
                )
        );

    let (host , port) = ([0,0,0,0], 3030);
    // let (host , port) = ([127,0,0,1], 3030);
    println!("Starting server on: {}:{}", host.map(|a| a.to_string()).join("."), port);
    warp::serve(routes)
        .run((host, port))
        .await;

}