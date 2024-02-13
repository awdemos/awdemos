# Use an official Python runtime as a parent image
FROM debian:latest

# Set the working directory in the container to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get install -y curl jq unzip gnupg

# Copy the current directory contents into the container at /app
COPY install_terraform.sh /app

# Make the script executable
RUN chmod +x /app/install_terraform.sh

# Run the script when the container launches
CMD ["/app/install_terraform.sh"]