# User Management System in Rust

## Overview

A Rust-based user management system with PostgreSQL backend, demonstrating user account management and database operations using tokio-postgres.

## Features

- User management with PostgreSQL persistence
- Docker containerization for development environment
- Automated database initialization and schema creation
- Bulk user insertion capabilities

## Prerequisites

- Docker and Docker Compose
- Rust toolchain
- Cargo package manager

## Project Structure

```
.
├── Cargo.lock
├── Cargo.toml
├── README.md
├── docker-compose.yaml
└── src
    ├── main.rs
    └── postgres.rs
```

## Database Schema

The system uses a PostgreSQL database with the following schema:

```sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    uri VARCHAR NOT NULL,
    active BOOLEAN NOT NULL
);
```

## Docker Environment

### Configuration

The `docker-compose.yaml` provides a development environment with:
- PostgreSQL database service
- Volume persistence for database data
- Health checks for service readiness
- Environment variable configuration

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
    environment:
      - DATABASE_URL=postgres://postgres:mysecretpassword@db:5432/users_db
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - .:/usr/src/app
    working_dir: /usr/src/app
    command: ["cargo", "run"]

  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: mysecretpassword
      POSTGRES_DB: users_db
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
    volumes:
      - db_data:/var/lib/postgresql/data
    expose:
      - "5432"

volumes:
  db_data:
```

## Quick Start

1. Start the services:
```bash
docker compose up -d
```

2. Run the application:
```bash
cargo run
```

3. Verify database entries:
```bash
docker exec -it db psql -U postgres -d users_db -c "SELECT * FROM users;"
```

## Development Commands

### Database Operations

Check database connection:
```bash
docker exec -it db psql -U postgres -d users_db
```

View table structure:
```bash
docker exec -it db psql -U postgres -d users_db -c "\d users"
```

### Container Management

Start services:
```bash
docker compose up -d
```

Stop services:
```bash
docker compose down
```

View logs:
```bash
docker compose logs -f
```

## Expected Output

After running the application:
```
✅ Successfully inserted user: alanturing
✅ Successfully inserted user: gracehopper
🎉 All users have been processed.
```

## Database Query Results

```sql
 id |  username   |      email       |        uri         | active 
----+-------------+------------------+--------------------+--------
  1 | alanturing  | alan@turing.com  | https://turing.com | t
  2 | gracehopper | grace@hopper.com | https://hopper.com | t
```

## Troubleshooting

1. Database Connection Issues:
   - Verify PostgreSQL container is healthy: `docker ps`
   - Check logs: `docker compose logs db`
   - Ensure correct connection string in `postgres.rs`

2. Application Errors:
   - Check application logs: `docker compose logs app`
   - Verify environment variables are set correctly
   - Ensure database migrations have run

## Cleanup

Remove all containers and volumes:
```bash
docker compose down -v
```

This README provides comprehensive setup instructions, development workflows, and troubleshooting guidance for your Rust user management system.
