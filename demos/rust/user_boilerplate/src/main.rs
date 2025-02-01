mod postgres;

use postgres::{initialize_database, insert_user, User};

/// Main function to demonstrate user management
#[tokio::main]
async fn main() {
    // Initialize the database and handle errors gracefully
    let client = match initialize_database().await {
        Ok(client) => client,
        Err(e) => {
            eprintln!("Error: Failed to initialize database - {}", e);
            return;
        }
    };

    // Define a list of users
    let users = vec![
        User::new(
            "alanturing".to_string(),
            "alan@turing.com".to_string(),
            "https://turing.com".to_string(),
        ),
        User::new(
            "gracehopper".to_string(),
            "grace@hopper.com".to_string(),
            "https://hopper.com".to_string(),
        ),
    ];

    // Insert users into the database
    for user in users {
        match insert_user(&client, &user).await {
            Ok(_) => println!("✅ Successfully inserted user: {}", user.username),
            Err(e) => eprintln!("❌ Error: Failed to insert user {} - {}", user.username, e),
        }
    }

    println!("🎉 All users have been processed.");
}

