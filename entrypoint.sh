#!/bin/bash

# Exit on first error
set -e

echo "--- Início da execução do entrypoint.sh ---"

# Definir o caminho absoluto para o Python do virtualenv
VENV_PYTHON="/opt/render/project/src/.venv/bin/python"

echo "Verificando e instalando dependências (se necessário)..."
# A CHAVE AQUI: Tentar instalar as dependências antes de tudo.
# Verificamos se o gunicorn já está acessível no ambiente.
# Se não estiver, tentamos instalá-lo e as demais dependências.
if ! "$VENV_PYTHON" -c "import gunicorn" &>/dev/null; then
    echo "Gunicorn não encontrado. Iniciando instalação de dependências via pip..."
    "$VENV_PYTHON" -m pip install --upgrade pip --verbose 2>&1
    "$VENV_PYTHON" -m pip install -r requirements.txt --verbose 2>&1
    echo "Instalação de dependências concluída. Verificando packages instalados:"
    "$VENV_PYTHON" -m pip freeze 2>&1 # Para depuração, lista o que foi instalado
else
    echo "Gunicorn já encontrado. Dependências provavelmente já instaladas."
fi

echo "Executando collectstatic..."
"$VENV_PYTHON" manage.py collectstatic --noinput 2>&1

echo "Executando migrações..."
"$VENV_PYTHON" manage.py migrate 2>&1

echo "Iniciando Gunicorn..."
"$VENV_PYTHON" -m gunicorn core.wsgi:application --bind 0.0.0.0:$PORT 2>&1

echo "--- entrypoint.sh finalizado com sucesso (esta linha não deve aparecer se Gunicorn iniciar corretamente) ---"