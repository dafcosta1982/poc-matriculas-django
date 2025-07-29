#!/bin/bash
set -e
/opt/render/project/src/.venv/bin/python manage.py collectstatic --noinput 2>&1
/opt/render/project/src/.venv/bin/python manage.py migrate 2>&1
/opt/render/project/src/.venv/bin/python -m gunicorn core.wsgi:application --bind 0.0.0.0:$PORT 2>&1