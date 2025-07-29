#!/bin/bash

# Exit on first error (mantemos para saber onde parou)
set -e

# Habilita o modo de depuração: imprime cada comando antes de executá-lo
set -x

echo "--- Início da execução do entrypoint.sh ---"

echo "Ativando ambiente virtual..."
# Redireciona stderr para stdout para garantir que mensagens de erro sejam capturadas
source /opt/render/project/src/.venv/bin/activate 2>&1

echo "Executando collectstatic..."
# Redireciona stderr para stdout
python manage.py collectstatic --noinput 2>&1

echo "Executando migrações..."
# Redireciona stderr para stdout
python manage.py migrate 2>&1

echo "Iniciando Gunicorn..."
# Redireciona stderr para stdout
/opt/render/project/src/.venv/bin/gunicorn core.wsgi:application --bind 0.0.0.0:$PORT

echo "--- entrypoint.sh finalizado com sucesso (esta linha não deve aparecer se Gunicorn iniciar corretamente) ---"