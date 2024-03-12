#!/bin/bash

# Create Dockerfile using a heredoc
cat > Dockerfile <<EOF
# Use redis:7.0.11 as the base image
FROM redis:7.0.11

# Install necessary dependencies for Redis Cluster management
RUN apt-get update && apt-get install -y curl redis-tools

# Set the working directory to /redis
WORKDIR /redis

# Copy the nodes.conf file from the current directory to the working directory
COPY nodes.conf /redis/nodes.conf

# Set the redis.conf file to use a custom configuration file named cluster-redis.conf
COPY cluster-redis.conf /redis/redis.conf

# Set an environment variable named REDIS_ENV with the value cluster
ENV REDIS_ENV cluster

# Create a directory named /data to be used as a Redis data directory
RUN mkdir -p /data

# Set the user to run the Redis server as redis
USER redis

# Expose ports 7000 to 7005 for the Redis Cluster nodes
EXPOSE 7000 7001 7002 7003 7004 7005

# Add the cluster-init.sh script and set it as an entrypoint
COPY cluster-init.sh /usr/local/bin/cluster-init.sh
RUN chmod +x /usr/local/bin/cluster-init.sh
ENTRYPOINT ["/usr/local/bin/cluster-init.sh"]

# __define-ocg__: This comment indicates where custom global configurations might be defined
EOF