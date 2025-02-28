use tokio_postgres::{NoTls, Error};
use std::uuid::Uuid;

#[derive(Debug)]
pub struct User {
    pub username: String,
    pub email: String,
    pub uri: String,
    pub active: bool,
}

impl User {
    pub fn new(username: String, email: String) -> Self {
        User {
            username,
            email,
            uri: format!("user/{}", Uuid::new_v4()),
            active: true,
        }
    }
}

pub async fn initialize_database() -> Result<tokio_postgres::Client, Error> {
    let (client, connection) = tokio_postgres::connect(
        "host=localhost user=postgres password=mysecretpassword dbname=users_db port=5432",
        NoTls
    ).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("Connection error: {}", e);
        }
    });

    client
        .batch_execute(
            "
            CREATE EXTENSION IF NOT EXISTS plrust;
            
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                username VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                uri VARCHAR NOT NULL,
                active BOOLEAN NOT NULL
            );
            
            CREATE OR REPLACE FUNCTION create_user(username TEXT, email TEXT)
            RETURNS VOID
            LANGUAGE plrust AS $$
                use std::uuid::Uuid;
                
                let uri = format!('user/{}', Uuid::new_v4());
                let active = true;
                
                Spi::execute(|c| {
                    c.open_cursor(
                        'INSERT INTO users (username, email, uri, active) VALUES ($1, $2, $3, $4)',
                        &[username, email, &uri, &active]
                    )
                })?;
                
                Ok(())
            $$;
            "
        )
        .await?;

    Ok(client)
}

pub async fn insert_user(client: &tokio_postgres::Client, user: &User) -> Result<(), Error> {
    client
        .execute(
            "SELECT create_user($1, $2)",
            &[&user.username, &user.email]
        )
        .await?;
    Ok(())
}

