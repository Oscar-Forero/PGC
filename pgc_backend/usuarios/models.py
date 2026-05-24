from django.db import models
from django.contrib.auth.models import User

class Perfil(models.Model):
    usuario = models.OneToOneField(User, on_delete=models.CASCADE, related_name='perfil')
    highscore = models.IntegerField(default=0)
    total_partidas = models.IntegerField(default=0)
    fecha_registro = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.usuario.first_name} - Highscore: {self.highscore}"

class Partida(models.Model):
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='partidas')
    puntaje = models.IntegerField(default=0)
    preguntas_correctas = models.IntegerField(default=0)
    preguntas_incorrectas = models.IntegerField(default=0)
    fecha = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.usuario.first_name} - Puntaje: {self.puntaje}"