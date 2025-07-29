{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww28560\viewh17440\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # core/settings.py\
import os\
from pathlib import Path\
import environ\
\
# Inicializa django-environ\
env = environ.Env(\
    # Defina o tipo de cada vari\'e1vel de ambiente\
    DEBUG=(bool, False),\
    DATABASE_URL=(str, 'sqlite:///db.sqlite3'), # Valor padr\'e3o para DEV LOCAL\
    SECRET_KEY=(str, 'INSECURE_SECRET_KEY_FOR_LOCAL_DEV'), # Valor padr\'e3o para DEV LOCAL\
    ALLOWED_HOSTS=(list, []),\
)\
\
# Constroi o caminho base do projeto\
BASE_DIR = Path(__file__).resolve().parent.parent\
\
# L\'ea o arquivo .env se existir (para desenvolvimento local)\
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))\
\
# Defini\'e7\'f5es de seguran\'e7a - Lidas das vari\'e1veis de ambiente ou .env\
SECRET_KEY = env('SECRET_KEY')\
DEBUG = env('DEBUG')\
ALLOWED_HOSTS = env('ALLOWED_HOSTS')\
\
\
# Application definition\
INSTALLED_APPS = [\
    'django.contrib.admin',\
    'django.contrib.auth',\
    'django.contrib.contenttypes',\
    'django.contrib.sessions',\
    'django.contrib.messages',\
    'django.contrib.staticfiles',\
    # Meus Apps\
    'alunos',\
]\
\
MIDDLEWARE = [\
    'django.middleware.security.SecurityMiddleware',\
    'whitenoise.middleware.WhiteNoiseMiddleware', # Adicionado para servir arquivos est\'e1ticos em produ\'e7\'e3o\
    'django.contrib.sessions.middleware.SessionMiddleware',\
    'django.middleware.common.CommonMiddleware',\
    'django.middleware.csrf.CsrfViewMiddleware',\
    'django.contrib.auth.middleware.AuthenticationMiddleware',\
    'django.contrib.messages.middleware.MessageMiddleware',\
    'django.middleware.clickjacking.XFrameOptionsMiddleware',\
]\
\
ROOT_URLCONF = 'core.urls'\
\
TEMPLATES = [\
    \{\
        'BACKEND': 'django.template.backends.django.DjangoTemplates',\
        'DIRS': [BASE_DIR / 'templates'], # Adicionado para encontrar templates na raiz\
        'APP_DIRS': True,\
        'OPTIONS': \{\
            'context_processors': [\
                'django.template.context_processors.debug',\
                'django.template.context_processors.request',\
                'django.contrib.auth.context_processors.auth',\
                'django.contrib.messages.context_processors.messages',\
            ],\
        \},\
    \},\
]\
\
WSGI_APPLICATION = 'core.wsgi.application'\
\
# Database - Lida das vari\'e1veis de ambiente ou .env\
DATABASES = \{\
    'default': env.db(),\
\}\
\
# Password validation\
AUTH_PASSWORD_VALIDATORS = [\
    \{\
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',\
    \},\
    \{\
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',\
    \},\
    \{\
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',\
    \},\
    \{\
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',\
    \},\
]\
\
# Internationalization\
LANGUAGE_CODE = 'pt-br'\
TIME_ZONE = 'America/Sao_Paulo' # Ajustado para fuso hor\'e1rio brasileiro\
USE_I18N = True\
USE_TZ = True\
\
\
# Static files (CSS, JavaScript, Images)\
STATIC_URL = '/static/'\
STATIC_ROOT = BASE_DIR / 'staticfiles' # Local para coletar arquivos est\'e1ticos em produ\'e7\'e3o\
\
# Configura Whitenoise para compactar e cachear arquivos est\'e1ticos\
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'\
\
\
# Default primary key field type\
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'}