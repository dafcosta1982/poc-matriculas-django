# alunos/models.py
from django.db import models

class Aluno(models.Model):
    nome_completo = models.CharField(max_length=200)
    data_nascimento = models.DateField()
    serie_pretendida = models.CharField(max_length=50)
    data_cadastro = models.DateTimeField(auto_now_add=True)
    observacoes = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.nome_completo

    class Meta:
        verbose_name = "Aluno"
        verbose_name_plural = "Alunos"
        ordering = ['nome_completo']