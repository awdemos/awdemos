use std::fmt;

/// Represents a user in the system with profile information
#[derive(Debug, Clone)]
struct User {
    username: String,
    email: String,
    uri: String,
    active: bool,
    last_modified: std::time::SystemTime,
}

impl User {
    /// Creates a new User instance with current timestamp
    fn new(username: String, email: String, uri: String) -> Self {
        User {
            username,
            email,
            uri,
            active: true,
            last_modified: std::time::SystemTime::now(),
        }
    }

    /// Deactivates the user account and updates timestamp
    fn deactivate(&mut self) {
        self.active = false;
        self.last_modified = std::time::SystemTime::now();
    }

    /// Activates the user account and updates timestamp
    fn activate(&mut self) {
        self.active = true;
        self.last_modified = std::time::SystemTime::now();
    }

    /// Updates email and timestamp
    fn update_email(&mut self, new_email: String) {
        self.email = new_email;
        self.last_modified = std::time::SystemTime::now();
    }

    /// Returns account status as a string
    fn status(&self) -> &str {
        if self.active { "Active" } else { "Inactive" }
    }
}

impl fmt::Display for User {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "User Profile:\n\
             Username: {}\n\
             Email: {}\n\
             Status: {}\n\
             Website: {}\n\
             Last Modified: {:?}",
            self.username,
            self.email,
            self.status(),
            self.uri,
            self.last_modified
        )
    }
}

fn main() {
    let mut turing = User::new(
        String::from("alanturing"),
        String::from("alan@turing.com"),
        String::from("https://turing.com"),
    );
    
    println!("{}", turing);
    
    turing.deactivate();
    println!("\nAfter deactivation:");
    println!("{}", turing);
    
    turing.update_email(String::from("turing@cambridge.edu"));
    turing.activate();
    println!("\nAfter email update and reactivation:");
    println!("{}", turing);
}

