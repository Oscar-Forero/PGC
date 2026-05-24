// ─────────────────────────────────────────────
//  Sesión del usuario activo
//  Guarda los datos en memoria durante la sesión
// ─────────────────────────────────────────────
class SesionUsuario {
  static String correo = '';
  static String nombre = '';

  /// Llama esto al hacer login exitoso
  static void iniciar({required String correo, required String nombre}) {
    SesionUsuario.correo = correo;
    SesionUsuario.nombre = nombre;
  }

  /// Llama esto al cerrar sesión
  static void cerrar() {
    correo = '';
    nombre = '';
  }

  /// Verifica si hay una sesión activa
  static bool get activa => correo.isNotEmpty;
}