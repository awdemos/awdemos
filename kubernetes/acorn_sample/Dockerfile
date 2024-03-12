# Use Chainguard Wolfi-base image with latest-dev tag
FROM cgr.dev/chainguard/wolfi-base

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ARG version=3.12
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

# Install Python and pip, assuming apk is available
RUN apk add --no-cache python-3.12-default \
   py3-setuptools \
   py3-pip
RUN pip3 install Flask && \
        chown -R nonroot.nonroot /app/

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt /app/

RUN python3 -m venv /venv

# Filter out the unwanted package and install dependencies
RUN pip3 install -r requirements.txt

# Copy the rest of the application
COPY . /app/

# Switch to nonroot user for security
# USER nonroot

# Set environment variables for Flask application
ENV DB_USER=demo_user
ENV DB_PASS=demo_pass
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=demo_db

ENV FLASK_APP templates/app.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 8000
ENV FLASK_ENV=development

# Expose the port the app runs on
EXPOSE 8000

# Run the Flask application
ENTRYPOINT ["/usr/bin/flask", "run", "--host=0.0.0.0", "--port=8000"]

