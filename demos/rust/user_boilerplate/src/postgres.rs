use tokio_postgres::{NoTls, Error};

#[derive(Debug)]
pub struct User {
    pub username: String,
    pub email: String,
    pub uri: String,
    pub active: bool,
}

impl User {
    pub fn new(username: String, email: String, uri: String) -> Self {
        User {
            username,
            email,
            uri,
            active: true,
        }
    }
}

pub async fn initialize_database() -> Result<tokio_postgres::Client, Error> {
    let (client, connection) = tokio_postgres::connect(
        "host=localhost \
         user=postgres \
         password=mysecretpassword \
         dbname=users_db \
         port=5432",
        NoTls
    ).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("Connection error: {}", e);
        }
    });

    client
        .execute(
            "CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                username VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                uri VARCHAR NOT NULL,
                active BOOLEAN NOT NULL
            )",
            &[],
        )
        .await?;

    Ok(client)
}

pub async fn insert_user(client: &tokio_postgres::Client, user: &User) -> Result<(), Error> {
    client
        .execute(
            "INSERT INTO users (username, email, uri, active) VALUES ($1, $2, $3, $4)",
            &[&user.username, &user.email, &user.uri, &user.active],
        )
        .await?;
    Ok(())
}

