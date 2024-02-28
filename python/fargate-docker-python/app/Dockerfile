# Use an official Python runtime as a parent image
FROM python:3.11-slim as builder

# Set the working directory in the container to /app
WORKDIR /app

# Add the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev
# RUN pip install --no-cache-dir -r requirements.txt

# Start a new stage for running the application
FROM python:3.11-slim as runner

# Copy the built application from the builder stage
COPY --from=builder /app /app

# Set the working directory in the container
WORKDIR /app

# name: The name of the image.
# vendor: The company name.
# version: The version of the image.
# release: A number that's used to identify the specific build for this image.
# summary: A short overview of the application or component in this image.
# description: A longer description of the application or component in this image.

LABEL name="my-namespace/my-image-name" \
      vendor="My Company, Inc." \
      version="1.2.3" \
      release="45" \
      summary="Web search application" \
      description="This application searches the web for interesting stuff."

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]