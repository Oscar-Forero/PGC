import 'package:flutter/material.dart';
import 'pantalla_registro.dart';
import 'pantalla_dashboard.dart';
import 'servicio_api.dart';
import 'sesion_usuario.dart';

// ─────────────────────────────────────────────
//  Pantalla principal de Inicio de Sesión
// ─────────────────────────────────────────────
class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _EstadoPantallaInicioSesion();
}

class _EstadoPantallaInicioSesion extends State<PantallaInicioSesion> {
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  bool _ocultarContrasena = true;
  bool _cargando = false;
  String? _mensajeError;

  // Errores por campo
  String? _errorCorreo;
  String? _errorContrasena;

  // ── Validaciones ──
  String? _validarCorreo(String valor) {
    if (valor.isEmpty) return 'El correo es obligatorio.';
    if (!valor.contains('@')) return 'El correo debe contener @.';
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(valor)) {
      return 'Ingresa un correo válido (ej: usuario@correo.com).';
    }
    return null;
  }

  String? _validarContrasena(String valor) {
    if (valor.isEmpty) return 'La contraseña es obligatoria.';
    return null;
  }

  bool _validarTodo() {
    setState(() {
      _errorCorreo = _validarCorreo(_controladorCorreo.text.trim());
      _errorContrasena = _validarContrasena(_controladorContrasena.text.trim());
      _mensajeError = null;
    });
    return _errorCorreo == null && _errorContrasena == null;
  }

  Future<void> _iniciarSesion() async {
    if (!_validarTodo()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final resultado = await ServicioApi.iniciarSesion(
      correo: _controladorCorreo.text.trim(),
      contrasena: _controladorContrasena.text.trim(),
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (resultado.exito) {
      SesionUsuario.iniciar(
        correo: _controladorCorreo.text.trim(),
        nombre: resultado.usuario?['nombre'] ?? '',
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaDashboard()),
      );
    } else {
      setState(() => _mensajeError = resultado.mensaje);
    }
  }

  void _mostrarDialogoOlvideContrasena() {
    showDialog(
      context: context,
      builder: (_) => const DialogoRecuperarContrasena(),
    );
  }

  void _irARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PantallaRegistro()),
    );
  }

  @override
  void dispose() {
    _controladorCorreo.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D0A6B),
              Color(0xFF7B2FF7),
              Color(0xFFC026D3),
            ],
          ),
        ),
        child: Column(
          children: [
            const BarraNavegacion(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: TarjetaInicioSesion(
                      controladorCorreo: _controladorCorreo,
                      controladorContrasena: _controladorContrasena,
                      ocultarContrasena: _ocultarContrasena,
                      cargando: _cargando,
                      mensajeError: _mensajeError,
                      errorCorreo: _errorCorreo,
                      errorContrasena: _errorContrasena,
                      alCambiarVisibilidad: () =>
                          setState(() => _ocultarContrasena = !_ocultarContrasena),
                      alIniciarSesion: _iniciarSesion,
                      alIrARegistro: _irARegistro,
                      alOlvideContrasena: _mostrarDialogoOlvideContrasena,
                      alCambiarCorreo: (_) => setState(() =>
                          _errorCorreo = _validarCorreo(_controladorCorreo.text.trim())),
                      alCambiarContrasena: (_) => setState(() =>
                          _errorContrasena = _validarContrasena(_controladorContrasena.text.trim())),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Barra de navegación superior
// ─────────────────────────────────────────────
class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'UDEC',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Flexible(
            child: Text(
              'PGC: Plataforma Gamificada de Codificación Python',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tarjeta de inicio de sesión
// ─────────────────────────────────────────────
class TarjetaInicioSesion extends StatelessWidget {
  final TextEditingController controladorCorreo;
  final TextEditingController controladorContrasena;
  final bool ocultarContrasena;
  final bool cargando;
  final String? mensajeError;
  final String? errorCorreo;
  final String? errorContrasena;
  final VoidCallback alCambiarVisibilidad;
  final VoidCallback alIniciarSesion;
  final VoidCallback alIrARegistro;
  final VoidCallback alOlvideContrasena;
  final void Function(String) alCambiarCorreo;
  final void Function(String) alCambiarContrasena;

  const TarjetaInicioSesion({
    super.key,
    required this.controladorCorreo,
    required this.controladorContrasena,
    required this.ocultarContrasena,
    required this.cargando,
    required this.mensajeError,
    required this.errorCorreo,
    required this.errorContrasena,
    required this.alCambiarVisibilidad,
    required this.alIniciarSesion,
    required this.alIrARegistro,
    required this.alOlvideContrasena,
    required this.alCambiarCorreo,
    required this.alCambiarContrasena,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 60,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                children: [
                  TextSpan(text: 'Bienvenido, ', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'PyJugador!', style: TextStyle(color: Color(0xFFF59E0B))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Inicia sesión para continuar tu aventura',
              style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 36),

          // ── Campo Correo ──
          const EtiquetaCampo('Correo Electrónico'),
          const SizedBox(height: 8),
          CampoTexto(
            controlador: controladorCorreo,
            sugerencia: 'tu@correo.com',
            icono: Icons.email_outlined,
            tipoPadre: TextInputType.emailAddress,
            error: errorCorreo,
            alCambiar: alCambiarCorreo,
          ),
          const SizedBox(height: 18),

          // ── Campo Contraseña ──
          const EtiquetaCampo('Contraseña'),
          const SizedBox(height: 8),
          CampoTexto(
            controlador: controladorContrasena,
            sugerencia: '••••••••',
            icono: Icons.lock_outline,
            ocultarTexto: ocultarContrasena,
            error: errorContrasena,
            alCambiar: alCambiarContrasena,
            iconoDerecho: IconButton(
              icon: Icon(
                ocultarContrasena
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white38,
                size: 20,
              ),
              onPressed: alCambiarVisibilidad,
            ),
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: alOlvideContrasena,
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Error del servidor ──
          if (mensajeError != null) ...[
            MensajeError(mensaje: mensajeError!),
            const SizedBox(height: 14),
          ],

          BotonPrincipal(
            etiqueta: '🎮  Iniciar Sesión',
            cargando: cargando,
            alPresionar: alIniciarSesion,
          ),
          const SizedBox(height: 20),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('¿No tienes cuenta? ', style: TextStyle(color: Colors.white38, fontSize: 13)),
                GestureDetector(
                  onTap: alIrARegistro,
                  child: const Text(
                    'Regístrate aquí',
                    style: TextStyle(color: Color(0xFFF59E0B), fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Widgets reutilizables
// ─────────────────────────────────────────────
class EtiquetaCampo extends StatelessWidget {
  final String texto;
  const EtiquetaCampo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700),
    );
  }
}

class CampoTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String sugerencia;
  final IconData icono;
  final bool ocultarTexto;
  final Widget? iconoDerecho;
  final TextInputType? tipoPadre;
  final String? error;
  final void Function(String)? alCambiar;

  const CampoTexto({
    super.key,
    required this.controlador,
    required this.sugerencia,
    required this.icono,
    this.ocultarTexto = false,
    this.iconoDerecho,
    this.tipoPadre,
    this.error,
    this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controlador,
          obscureText: ocultarTexto,
          keyboardType: tipoPadre,
          onChanged: alCambiar,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: sugerencia,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(
              icono,
              color: error != null ? Colors.redAccent : Colors.white38,
              size: 20,
            ),
            suffixIcon: iconoDerecho,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.07),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? Colors.redAccent : Colors.white.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? Colors.redAccent : const Color(0xFF7C3AED),
                width: 1.5,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class MensajeError extends StatelessWidget {
  final String mensaje;
  const MensajeError({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class BotonPrincipal extends StatelessWidget {
  final String etiqueta;
  final bool cargando;
  final VoidCallback alPresionar;

  const BotonPrincipal({
    super.key,
    required this.etiqueta,
    required this.cargando,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFC026D3)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: cargando ? null : alPresionar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: cargando
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Text(etiqueta, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Diálogo: Recuperar Contraseña
// ─────────────────────────────────────────────
class DialogoRecuperarContrasena extends StatefulWidget {
  const DialogoRecuperarContrasena({super.key});

  @override
  State<DialogoRecuperarContrasena> createState() => _EstadoDialogoRecuperarContrasena();
}

class _EstadoDialogoRecuperarContrasena extends State<DialogoRecuperarContrasena> {
  final _controladorCorreo = TextEditingController();
  bool _enviando = false;
  bool _enviado = false;
  String? _errorCorreo;

  String? _validarCorreo(String valor) {
    if (valor.isEmpty) return 'Ingresa tu correo electrónico.';
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(valor)) {
      return 'Ingresa un correo válido (ej: usuario@correo.com).';
    }
    return null;
  }

  void _enviarRecuperacion() async {
    final error = _validarCorreo(_controladorCorreo.text.trim());
    setState(() => _errorCorreo = error);
    if (error != null) return;

    setState(() { _enviando = true; _errorCorreo = null; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() { _enviando = false; _enviado = true; });
  }

  @override
  void dispose() { _controladorCorreo.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext contexto) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D0A6B), Color(0xFF7B2FF7)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 60, offset: const Offset(0, 24))],
        ),
        child: _enviado ? _vistaConfirmacion(contexto) : _vistaFormulario(),
      ),
    );
  }

  Widget _vistaFormulario() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.lock_reset_rounded, color: Color(0xFFF59E0B), size: 28),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text('¿Olvidaste tu contraseña?',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Ingresa tu correo y te enviaremos\ninstrucciones para recuperarla.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
        const SizedBox(height: 28),
        const EtiquetaCampo('Correo Electrónico'),
        const SizedBox(height: 8),
        CampoTexto(
          controlador: _controladorCorreo,
          sugerencia: 'tu@correo.com',
          icono: Icons.email_outlined,
          tipoPadre: TextInputType.emailAddress,
          error: _errorCorreo,
          alCambiar: (_) => setState(() => _errorCorreo = _validarCorreo(_controladorCorreo.text.trim())),
        ),
        const SizedBox(height: 16),
        BotonPrincipal(etiqueta: '📧  Enviar instrucciones', cargando: _enviando, alPresionar: _enviarRecuperacion),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _vistaConfirmacion(BuildContext contexto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.5)),
          ),
          child: const Icon(Icons.mark_email_read_outlined, color: Color(0xFF4ADE80), size: 32),
        ),
        const SizedBox(height: 20),
        const Text('¡Correo enviado!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Text(
          'Revisa tu bandeja de entrada en\n${_controladorCorreo.text.trim()}\ny sigue las instrucciones.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 28),
        BotonPrincipal(etiqueta: '✅  Entendido', cargando: false, alPresionar: () => Navigator.pop(contexto)),
      ],
    );
  }
}