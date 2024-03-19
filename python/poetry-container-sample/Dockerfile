# Use a Chainguard base image
FROM ghcr.io/chainguard-images/python:latest-dev as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    POETRY_VERSION=1.8.2

# Install Poetry
RUN python -m pip install "poetry==$POETRY_VERSION"

# Set work directory
WORKDIR /app

# Copy the project files into the working directory
COPY pyproject.toml poetry.lock* /app/

# Start a new stage from a Chainguard runtime image to keep the final image minimal
FROM ghcr.io/chainguard-images/python:latest-dev

WORKDIR /app

# Copy the rest of your application's code
COPY . /app

# Command to run your application
CMD ["python", "__init__.py"]

