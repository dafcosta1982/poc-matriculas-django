#!/bin/bash

# Exit on first error
set -e

# Habilita o modo de depuração: imprime cada comando antes de executá-lo
set -x

echo "--- Início da execução do entrypoint.sh ---"

# Não é mais necessário "source activate" se chamarmos o python do venv diretamente
# removemos esta linha para simplificar e focar no problema
# echo "Ativando ambiente virtual..."
# source /opt/render/project/src/.venv/bin/activate 2>&1

echo "Executando collectstatic..."
# Usamos o caminho absoluto para o python do virtualenv
/opt/render/project/src/.venv/bin/python manage.py collectstatic --noinput 2>&1

echo "Executando migrações..."
# Usamos o caminho absoluto para o python do virtualenv
/opt/render/project/src/.venv/bin/python manage.py migrate 2>&1

echo "Iniciando Gunicorn..."
# A CHAVE AQUI: Usamos o python do virtualenv para executar o gunicorn como um módulo
/opt/render/project/src/.venv/bin/python -m gunicorn core.wsgi:application --bind 0.0.0.0:$PORT 2>&1

echo "--- entrypoint.sh finalizado com sucesso (esta linha não deve aparecer se Gunicorn iniciar corretamente) ---"