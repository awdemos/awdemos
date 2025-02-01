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

### Example Usage
The main function demonstrates:
1. Creating a new user (Alan Turing).
2. Printing their details.
3. Deactivating their account.
4. Updating their email address.
5. Reactivating their account.


