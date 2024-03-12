podman build -t acorn .
podman run -it --entrypoint /bin/sh localhost/acorn:latest
podman run -d -p 8000:8000 --entrypoint /bin/sh localhost/acorn:latest -c "flask run --host=0.0.0.0 --port=8000"

acorn login

acorn run -n my-todo .

# Stop all the apps
acorn ps | awk 'NR>1 {print $1}' | xargs -I {} acorn stop {}

export FLASK_APP=templates/app.py
export FLASK_RUN_HOST=0.0.0.0
export FLASK_RUN_PORT=8000
export FLASK_ENV=development

flask --version
source /venv/bin/activate
flask run --host=0.0.0.0 --port=8000

flask --version && source /venv/bin/activate && flask run --host=0.0.0.0 --port=8000

podman build -t acorn .
podman run -d -p 8000:8000 --name acorn_instance -e FLASK_ENV=development localhost/acorn:latest

podman stop acorn_instance
podman rm acorn_instance
podman run -d -p 8000:8000 --name acorn_instance -e FLASK_ENV=development localhost/acorn:latest
