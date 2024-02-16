# Use a base image
FROM python:3.12-slim

# Install dependencies
RUN pip install requests

# Embed Python code to dynamically define environment variables
# Python block starts with `#PY` and ends with `#END`
#PY
import os
env_vars = {
    "ENVIRONMENT": "development" if os.path.exists("/path/to/dev/flag") else "production",
}
for key, value in env_vars.items():
    print(f"ENV {key}={value}")
#END

# Standard Dockerfile instruction follows
COPY . /app
WORKDIR /app
CMD ["python", "app.py"]