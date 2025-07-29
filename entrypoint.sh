#!/bin/bash

# Exit on first error
set -e

echo "--- Início da execução do entrypoint.sh ---"

# Definir o caminho absoluto para o Python do virtualenv e o root do projeto
VENV_PYTHON="/opt/render/project/src/.venv/bin/python"
PROJECT_ROOT="/opt/render/project/src"

echo "Diretório de trabalho atual: $(pwd)"
echo "Listando conteúdo do root do projeto ($PROJECT_ROOT):"
ls -la "$PROJECT_ROOT"
echo "Listando conteúdo do diretório bin do ambiente virtual ($PROJECT_ROOT/.venv/bin):"
ls -la "$PROJECT_ROOT/.venv/bin"

echo "Verificando e instalando dependências (se necessário)..."
# A CHAVE AQUI: Tentar instalar as dependências antes de tudo.
# Verificamos se o gunicorn já está acessível no ambiente.
# Se não estiver, tentamos instalá-lo e as demais dependências.
if ! "$VENV_PYTHON" -c "import gunicorn" &>/dev/null; then
    echo "Gunicorn não encontrado. Iniciando instalação de dependências via pip..."

    # Verificar se requirements.txt existe
    if [ -f "$PROJECT_ROOT/requirements.txt" ]; then
        echo "requirements.txt encontrado em $PROJECT_ROOT/requirements.txt"
    else
        echo "ERRO: requirements.txt NÃO ENCONTRADO em $PROJECT_ROOT/requirements.txt. Saindo."
        exit 1
    fi

    echo "Tentando atualizar o pip..."
    "$VENV_PYTHON" -m pip install --upgrade pip --verbose 2>&1 || { echo "ERRO: Falha ao atualizar o pip. Saindo." >&2; exit 1; }

    echo "Tentando instalar dependências do requirements.txt..."
    # Usar um caminho explícito para requirements.txt para evitar problemas de CWD
    "$VENV_PYTHON" -m pip install -r "$PROJECT_ROOT/requirements.txt" --verbose 2>&1 || { echo "ERRO: Falha ao instalar dependências. Saindo." >&2; exit 1; }

    echo "Tentativa de instalação concluída. Listando pacotes instalados:"
    "$VENV_PYTHON" -m pip list --verbose 2>&1 # Usando pip list para saída mais detalhada
    echo "Fim da lista de pacotes instalados."
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