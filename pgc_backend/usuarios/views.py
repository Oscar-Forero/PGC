import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .models import Perfil, Partida

@csrf_exempt
def login(request):
    if request.method != 'POST':
        return JsonResponse({'exito': False, 'mensaje': 'Método no permitido.'}, status=405)
    try:
        data = json.loads(request.body)
        correo = data.get('correo', '')
        contrasena = data.get('contrasena', '')
        try:
            user = User.objects.get(email=correo)
        except User.DoesNotExist:
            return JsonResponse({'exito': False, 'mensaje': 'El correo no está registrado.'}, status=401)
        user = authenticate(username=user.username, password=contrasena)
        if user:
            return JsonResponse({
                'exito': True,
                'usuario': {'nombre': user.first_name, 'correo': user.email}
            })
        else:
            return JsonResponse({'exito': False, 'mensaje': 'Contraseña incorrecta.'}, status=401)
    except Exception as e:
        return JsonResponse({'exito': False, 'mensaje': str(e)}, status=500)


@csrf_exempt
def registro(request):
    if request.method != 'POST':
        return JsonResponse({'exito': False, 'mensaje': 'Método no permitido.'}, status=405)
    try:
        data = json.loads(request.body)
        nombre = data.get('nombre', '')
        correo = data.get('correo', '')
        contrasena = data.get('contrasena', '')
        if User.objects.filter(email=correo).exists():
            return JsonResponse({'exito': False, 'mensaje': 'Este correo ya está registrado.'}, status=400)
        User.objects.create_user(
            username=correo,
            email=correo,
            password=contrasena,
            first_name=nombre
        )
        return JsonResponse({'exito': True, 'mensaje': 'Cuenta creada con éxito.'}, status=201)
    except Exception as e:
        return JsonResponse({'exito': False, 'mensaje': str(e)}, status=500)


@csrf_exempt
def guardar_partida(request):
    if request.method != 'POST':
        return JsonResponse({'exito': False, 'mensaje': 'Método no permitido.'}, status=405)
    try:
        data = json.loads(request.body)
        correo = data.get('correo', '')
        puntaje = data.get('puntaje', 0)
        preguntas_correctas = data.get('preguntas_correctas', 0)
        preguntas_incorrectas = data.get('preguntas_incorrectas', 0)

        user = User.objects.get(email=correo)

        Partida.objects.create(
            usuario=user,
            puntaje=puntaje,
            preguntas_correctas=preguntas_correctas,
            preguntas_incorrectas=preguntas_incorrectas,
        )

        perfil, _ = Perfil.objects.get_or_create(usuario=user)
        perfil.total_partidas += 1
        if puntaje > perfil.highscore:
            perfil.highscore = puntaje
        perfil.save()

        return JsonResponse({'exito': True, 'mensaje': 'Partida guardada.', 'highscore': perfil.highscore})
    except User.DoesNotExist:
        return JsonResponse({'exito': False, 'mensaje': 'Usuario no encontrado.'}, status=404)
    except Exception as e:
        return JsonResponse({'exito': False, 'mensaje': str(e)}, status=500)


@csrf_exempt
def obtener_perfil(request):
    if request.method != 'POST':
        return JsonResponse({'exito': False, 'mensaje': 'Método no permitido.'}, status=405)
    try:
        data = json.loads(request.body)
        correo = data.get('correo', '')

        user = User.objects.get(email=correo)
        perfil, _ = Perfil.objects.get_or_create(usuario=user)
        partidas = Partida.objects.filter(usuario=user).order_by('-fecha')[:10]

        historial = [
            {
                'puntaje': p.puntaje,
                'preguntas_correctas': p.preguntas_correctas,
                'preguntas_incorrectas': p.preguntas_incorrectas,
                'fecha': p.fecha.strftime('%d/%m/%Y %H:%M'),
            }
            for p in partidas
        ]

        return JsonResponse({
            'exito': True,
            'nombre': user.first_name,
            'correo': user.email,
            'highscore': perfil.highscore,
            'total_partidas': perfil.total_partidas,
            'historial': historial,
        })
    except User.DoesNotExist:
        return JsonResponse({'exito': False, 'mensaje': 'Usuario no encontrado.'}, status=404)
    except Exception as e:
        return JsonResponse({'exito': False, 'mensaje': str(e)}, status=500)