# User Management System in Rust

## Overview

This project demonstrates a simple user management system implemented in Rust. It includes a `User` struct that represents a user's profile and provides functionality to manage user accounts, such as activation, deactivation, email updates, and status tracking.

## Features

- **User Struct**: Represents user data with fields for username, email, URI, account status, and last modification timestamp.
- **Account Management**: Includes methods to activate, deactivate, and update user details.
- **Timestamp Tracking**: Automatically updates the `last_modified` field whenever a change is made to the user's account.
- **Display Trait**: Implements the `fmt::Display` trait for formatted output of user details.

## Code Explanation

### Struct Definition
The `User` struct contains the following fields:
- `username`: The username of the user.
- `email`: The email address of the user.
- `uri`: The user's website or profile link.
- `active`: A boolean indicating whether the account is active.
- `last_modified`: A timestamp indicating the last time the user's data was modified.

### Methods
1. **`new`**: Creates a new user instance with default active status and sets the current timestamp as `last_modified`.
2. **`deactivate`**: Sets the user's status to inactive and updates the timestamp.
3. **`activate`**: Sets the user's status to active and updates the timestamp.
4. **`update_email`**: Updates the user's email address and modifies the timestamp.
5. **`status`**: Returns a string representation of the user's account status ("Active" or "Inactive").

### Display Implementation
The `fmt::Display` trait is implemented for the `User` struct to provide a clean and readable format for printing user details.

---

## Running PostgreSQL with Docker

To run PostgreSQL in Docker for this project:

1. Start a PostgreSQL container:
   ```bash
   docker run -d \
     --name postgres-users \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=mysecretpassword \
     -e POSTGRES_DB=users_db \
     -p 5432:5432 \
     postgres:latest
   ```

   - `POSTGRES_USER=postgres`: Sets the username to `postgres`.
   - `POSTGRES_PASSWORD=mysecretpassword`: Sets the password to `mysecretpassword`.
   - `POSTGRES_DB=users_db`: Creates a database named `users_db`.
   - `-p 5432:5432`: Maps port 5432 on your machine to port 5432 in the container.

2. Verify that PostgreSQL is running:
   ```bash
   docker ps
   ```

---

## Running the Application

1. Build and run your Rust application:
   ```bash
   cargo run
   ```

2. Expected output:
   ```
   ✅ Successfully inserted user: alanturing
   ✅ Successfully inserted user: gracehopper
   🎉 All users have been processed.
   ```

---

## Querying Users in PostgreSQL

To verify that users were inserted into the database:

1. Run this one-liner in Bash:
   ```bash
   docker exec -it postgres-users psql -U postgres -d users_db -c "SELECT * FROM users;"
   ```

2. Expected output:
   ```
    id |  username   |      email       |        uri         | active 
   ----+-------------+------------------+--------------------+--------
     1 | alanturing  | alan@turing.com  | https://turing.com | t
     2 | gracehopper | grace@hopper.com | https://hopper.com | t
   (2 rows)
   ```

---

## Example Usage

The main function demonstrates:
1. Creating new users (Alan Turing and Grace Hopper).
2. Inserting them into a PostgreSQL database.
3. Printing success messages for each operation.

---

## Stopping or Restarting PostgreSQL

To stop or restart your PostgreSQL container:

- Stop the container:
  ```bash
  docker stop postgres-users
  ```

- Restart the container:
  ```bash
  docker start postgres-users
  ```

- Remove the container (if needed):
  ```bash
  docker rm -f postgres-users
  ```

---

This README includes all necessary Docker instructions, commands to query inserted users, and expected outputs for your Rust application!
