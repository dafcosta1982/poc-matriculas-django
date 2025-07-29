# alunos/urls.py
from django.urls import path
from .views import AlunoListView, AlunoDetailView, AlunoCreateView, AlunoUpdateView, AlunoDeleteView

urlpatterns = [
    path('', AlunoListView.as_view(), name='aluno_list'),
    path('novo/', AlunoCreateView.as_view(), name='aluno_create'),
    path('<int:pk>/', AlunoDetailView.as_view(), name='aluno_detail'),
    path('<int:pk>/editar/', AlunoUpdateView.as_view(), name='aluno_update'),
    path('<int:pk>/deletar/', AlunoDeleteView.as_view(), name='aluno_delete'),
]