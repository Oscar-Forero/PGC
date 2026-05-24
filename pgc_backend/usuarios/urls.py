from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login),
    path('registro/', views.registro),
    path('guardar_partida/', views.guardar_partida),
    path('obtener_perfil/', views.obtener_perfil),
]