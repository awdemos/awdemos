# Use a lightweight base image
FROM python:3.11-slim

# Install dependencies
RUN pip install --no-cache-dir gunicorn requests

# Create a Python user
RUN groupadd --gid 1000 python && \
    useradd --uid 1000 --gid python --shell /bin/bash --create-home python

# Switch to Python user
USER python

WORKDIR /home/python/app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Expose port
EXPOSE 8000

# Run command
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "app:app"]

