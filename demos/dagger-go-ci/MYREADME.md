## Dagger Commands Overview

This document outlines the Dagger commands used to test, lint, build, and serve the application. Each command is designed to facilitate different stages of the Continuous Integration/Continuous Deployment (CI/CD) pipeline.

### Test the Application

Run unit tests for both the backend and frontend components of the project.

```dagger call -m ./ci test --dir "."```

### Lint the Code

Perform linting on the project's codebase to ensure code quality and consistency.

```dagger call -m ./ci lint --dir "."```

### Build the Project

Build the project for a specified environment. This command compiles both the backend and frontend parts of the application.

```dagger call -m ./ci build --dir "." --env dev```


### Serve the Application

Serve the backend and frontend on local ports. This command makes the application accessible for testing or local development.

```dagger call serve --dir "." up```

You can access the application as follows:

Backend: Accessible at http://localhost:8080
Frontend: Accessible at http://localhost:8081


```
dagger call -m github.com/purpleclay/daggerverse/trivy image --ref golang:1.21.7-bookworm
dagger call -m github.com/purpleclay/daggerverse/trivy image --ref cgr.dev/chainguard
```