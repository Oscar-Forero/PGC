import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://127.0.0.1:8000/api';

class ResultadoAuth {
  final bool exito;
  final String mensaje;
  final Map<String, dynamic>? usuario;

  const ResultadoAuth({
    required this.exito,
    required this.mensaje,
    this.usuario,
  });
}

class ServicioApi {
  // ── LOGIN ──
  static Future<ResultadoAuth> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['exito'] == true) {
        return ResultadoAuth(
          exito: true,
          mensaje: 'Inicio de sesión exitoso',
          usuario: data['usuario'] as Map<String, dynamic>?,
        );
      } else {
        return ResultadoAuth(
          exito: false,
          mensaje: data['mensaje'] as String? ?? 'Credenciales incorrectas.',
        );
      }
    } on Exception catch (e) {
      return ResultadoAuth(
        exito: false,
        mensaje: 'No se pudo conectar al servidor. Verifica tu conexión.\n($e)',
      );
    }
  }

  // ── REGISTRO ──
  static Future<ResultadoAuth> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/registro/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nombre': nombre,
              'correo': correo,
              'contrasena': contrasena,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['exito'] == true) {
        return ResultadoAuth(
          exito: true,
          mensaje: data['mensaje'] as String? ?? 'Cuenta creada con éxito.',
        );
      } else {
        return ResultadoAuth(
          exito: false,
          mensaje: data['mensaje'] as String? ?? 'No se pudo crear la cuenta.',
        );
      }
    } on Exception catch (e) {
      return ResultadoAuth(
        exito: false,
        mensaje: 'No se pudo conectar al servidor. Verifica tu conexión.\n($e)',
      );
    }
  }

  // ── GUARDAR PARTIDA ──
  static Future<ResultadoAuth> guardarPartida({
    required String correo,
    required int puntaje,
    required int preguntasCorrectas,
    required int preguntasIncorrectas,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/guardar_partida/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'correo': correo,
              'puntaje': puntaje,
              'preguntas_correctas': preguntasCorrectas,
              'preguntas_incorrectas': preguntasIncorrectas,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['exito'] == true) {
        return ResultadoAuth(
          exito: true,
          mensaje: data['mensaje'] as String? ?? 'Partida guardada.',
        );
      } else {
        return ResultadoAuth(
          exito: false,
          mensaje: data['mensaje'] as String? ?? 'No se pudo guardar la partida.',
        );
      }
    } on Exception catch (e) {
      return ResultadoAuth(
        exito: false,
        mensaje: 'Error al guardar partida.\n($e)',
      );
    }
  }

  // ── OBTENER PERFIL ──
  static Future<ResultadoAuth> obtenerPerfil({
    required String correo,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/obtener_perfil/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['exito'] == true) {
        return ResultadoAuth(
          exito: true,
          mensaje: 'Perfil obtenido.',
          usuario: data,
        );
      } else {
        return ResultadoAuth(
          exito: false,
          mensaje: data['mensaje'] as String? ?? 'No se pudo obtener el perfil.',
        );
      }
    } on Exception catch (e) {
      return ResultadoAuth(
        exito: false,
        mensaje: 'Error al obtener perfil.\n($e)',
      );
    }
  }
}

