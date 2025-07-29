# alunos/admin.py
from django.contrib import admin
from .models import Aluno

@admin.register(Aluno)
class AlunoAdmin(admin.ModelAdmin):
    list_display = ('nome_completo', 'data_nascimento', 'serie_pretendida', 'data_cadastro')
    search_fields = ('nome_completo', 'serie_pretendida')
    list_filter = ('serie_pretendida',)
    date_hierarchy = 'data_cadastro'