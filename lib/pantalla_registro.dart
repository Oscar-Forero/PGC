import 'package:flutter/material.dart';
import 'servicio_api.dart';

// ─────────────────────────────────────────────
//  Validaciones centralizadas
// ─────────────────────────────────────────────
class Validador {
  /// Nombre: solo letras y espacios, mínimo 3 caracteres
  static String? nombre(String valor) {
    if (valor.isEmpty) return 'El nombre es obligatorio.';
    if (valor.length < 3) return 'El nombre debe tener al menos 3 caracteres.';
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(valor)) {
      return 'El nombre solo puede contener letras.';
    }
    return null;
  }

  /// Correo: debe tener @ y dominio con punto
  static String? correo(String valor) {
    if (valor.isEmpty) return 'El correo es obligatorio.';
    if (!valor.contains('@')) return 'El correo debe contener @.';
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(valor)) {
      return 'Ingresa un correo válido (ej: usuario@correo.com).';
    }
    return null;
  }

  /// Contraseña: mínimo 6 chars, al menos 1 letra, 1 número y 1 carácter especial
  static String? contrasena(String valor) {
    if (valor.isEmpty) return 'La contraseña es obligatoria.';
    if (valor.length < 6) return 'Mínimo 6 caracteres.';
    if (!RegExp(r'[a-zA-Z]').hasMatch(valor)) return 'Debe contener al menos una letra.';
    if (!RegExp(r'[0-9]').hasMatch(valor)) return 'Debe contener al menos un número.';
    if (!RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(valor)) {
      return 'Debe contener al menos un carácter especial (!@#\$%...).';
    }
    return null;
  }

  /// Confirmar contraseña: debe coincidir
  static String? confirmarContrasena(String valor, String original) {
    if (valor.isEmpty) return 'Por favor confirma tu contraseña.';
    if (valor != original) return 'Las contraseñas no coinciden.';
    return null;
  }
}

// ─────────────────────────────────────────────
//  Pantalla de Registro
// ─────────────────────────────────────────────
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _EstadoPantallaRegistro();
}

class _EstadoPantallaRegistro extends State<PantallaRegistro> {
  final _controladorNombre = TextEditingController();
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  final _controladorConfirmarContrasena = TextEditingController();

  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;
  bool _cargando = false;

  // Errores individuales por campo
  String? _errorNombre;
  String? _errorCorreo;
  String? _errorContrasena;
  String? _errorConfirmacion;
  String? _errorServidor;

  bool _validarTodo() {
    setState(() {
      _errorNombre = Validador.nombre(_controladorNombre.text.trim());
      _errorCorreo = Validador.correo(_controladorCorreo.text.trim());
      _errorContrasena = Validador.contrasena(_controladorContrasena.text.trim());
      _errorConfirmacion = Validador.confirmarContrasena(
        _controladorConfirmarContrasena.text.trim(),
        _controladorContrasena.text.trim(),
      );
      _errorServidor = null;
    });
    return _errorNombre == null &&
        _errorCorreo == null &&
        _errorContrasena == null &&
        _errorConfirmacion == null;
  }

  Future<void> _registrarse() async {
    if (!_validarTodo()) return;

    setState(() => _cargando = true);

    final resultado = await ServicioApi.registrarUsuario(
      nombre: _controladorNombre.text.trim(),
      correo: _controladorCorreo.text.trim(),
      contrasena: _controladorContrasena.text.trim(),
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (resultado.exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎮 ¡Cuenta creada con éxito! Ya puedes iniciar sesión.'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
      Navigator.pop(context);
    } else {
      setState(() => _errorServidor = resultado.mensaje);
    }
  }

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorCorreo.dispose();
    _controladorContrasena.dispose();
    _controladorConfirmarContrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D0A6B), Color(0xFF7B2FF7), Color(0xFFC026D3)],
          ),
        ),
        child: Column(
          children: [
            _barraNavegacion(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
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
                          // Título
                          Center(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                                children: [
                                  TextSpan(text: '¡Únete, ', style: TextStyle(color: Colors.white)),
                                  TextSpan(text: 'PyJugador!', style: TextStyle(color: Color(0xFFF59E0B))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Crea tu cuenta y comienza la aventura',
                              style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Nombre
                          _EtiquetaCampo('Nombre de Usuario'),
                          const SizedBox(height: 8),
                          _CampoTexto(
                            controlador: _controladorNombre,
                            sugerencia: 'PyJugador123',
                            icono: Icons.person_outline,
                            tipo: TextInputType.name,
                            error: _errorNombre,
                            alCambiar: (_) => setState(() => _errorNombre = Validador.nombre(_controladorNombre.text.trim())),
                          ),
                          const SizedBox(height: 18),

                          // Correo
                          _EtiquetaCampo('Correo Electrónico'),
                          const SizedBox(height: 8),
                          _CampoTexto(
                            controlador: _controladorCorreo,
                            sugerencia: 'tu@correo.com',
                            icono: Icons.email_outlined,
                            tipo: TextInputType.emailAddress,
                            error: _errorCorreo,
                            alCambiar: (_) => setState(() => _errorCorreo = Validador.correo(_controladorCorreo.text.trim())),
                          ),
                          const SizedBox(height: 18),

                          // Contraseña
                          _EtiquetaCampo('Contraseña'),
                          const SizedBox(height: 8),
                          _CampoTexto(
                            controlador: _controladorContrasena,
                            sugerencia: 'Min. 6 chars, número y símbolo',
                            icono: Icons.lock_outline,
                            ocultar: _ocultarContrasena,
                            error: _errorContrasena,
                            alCambiar: (_) => setState(() => _errorContrasena = Validador.contrasena(_controladorContrasena.text.trim())),
                            iconoDerecho: IconButton(
                              icon: Icon(
                                _ocultarContrasena ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: Colors.white38, size: 20,
                              ),
                              onPressed: () => setState(() => _ocultarContrasena = !_ocultarContrasena),
                            ),
                          ),
                          // Indicador de fortaleza
                          if (_controladorContrasena.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _IndicadorFortaleza(contrasena: _controladorContrasena.text),
                          ],
                          const SizedBox(height: 18),

                          // Confirmar contraseña
                          _EtiquetaCampo('Confirmar Contraseña'),
                          const SizedBox(height: 8),
                          _CampoTexto(
                            controlador: _controladorConfirmarContrasena,
                            sugerencia: '••••••••',
                            icono: Icons.lock_outline,
                            ocultar: _ocultarConfirmacion,
                            error: _errorConfirmacion,
                            alCambiar: (_) => setState(() => _errorConfirmacion = Validador.confirmarContrasena(
                              _controladorConfirmarContrasena.text.trim(),
                              _controladorContrasena.text.trim(),
                            )),
                            iconoDerecho: IconButton(
                              icon: Icon(
                                _ocultarConfirmacion ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: Colors.white38, size: 20,
                              ),
                              onPressed: () => setState(() => _ocultarConfirmacion = !_ocultarConfirmacion),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Error del servidor
                          if (_errorServidor != null) ...[
                            _MensajeError(mensaje: _errorServidor!),
                            const SizedBox(height: 14),
                          ],

                          // Botón registrarse
                          _BotonPrincipal(
                            etiqueta: '🎮  Crear Cuenta',
                            cargando: _cargando,
                            alPresionar: _registrarse,
                          ),
                          const SizedBox(height: 20),

                          // Ir a login
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('¿Ya tienes cuenta? ', style: TextStyle(color: Colors.white38, fontSize: 13)),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Inicia sesión aquí',
                                    style: TextStyle(color: Color(0xFFF59E0B), fontSize: 13, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _barraNavegacion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(8)),
            child: const Text('UDEC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
          ),
          const SizedBox(width: 14),
          const Flexible(
            child: Text('PGC: Plataforma Gamificada de Codificación Python',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Indicador de fortaleza de contraseña
// ─────────────────────────────────────────────
class _IndicadorFortaleza extends StatelessWidget {
  final String contrasena;
  const _IndicadorFortaleza({required this.contrasena});

  int get _nivel {
    int puntos = 0;
    if (contrasena.length >= 6) puntos++;
    if (RegExp(r'[a-zA-Z]').hasMatch(contrasena)) puntos++;
    if (RegExp(r'[0-9]').hasMatch(contrasena)) puntos++;
    if (RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(contrasena)) puntos++;
    return puntos;
  }

  Color get _color {
    if (_nivel <= 1) return Colors.red;
    if (_nivel == 2) return Colors.orange;
    if (_nivel == 3) return Colors.yellow;
    return const Color(0xFF16A34A);
  }

  String get _texto {
    if (_nivel <= 1) return 'Muy débil';
    if (_nivel == 2) return 'Débil';
    if (_nivel == 3) return 'Aceptable';
    return '¡Fuerte!';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              height: 4,
              decoration: BoxDecoration(
                color: i < _nivel ? _color : Colors.white12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
        ),
        const SizedBox(height: 4),
        Text(
          'Fortaleza: $_texto',
          style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Widgets reutilizables
// ─────────────────────────────────────────────
class _EtiquetaCampo extends StatelessWidget {
  final String texto;
  const _EtiquetaCampo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700));
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String sugerencia;
  final IconData icono;
  final bool ocultar;
  final Widget? iconoDerecho;
  final TextInputType? tipo;
  final String? error;
  final void Function(String)? alCambiar;

  const _CampoTexto({
    required this.controlador,
    required this.sugerencia,
    required this.icono,
    this.ocultar = false,
    this.iconoDerecho,
    this.tipo,
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
          obscureText: ocultar,
          keyboardType: tipo,
          onChanged: alCambiar,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: sugerencia,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(icono, color: error != null ? Colors.redAccent : Colors.white38, size: 20),
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

class _MensajeError extends StatelessWidget {
  final String mensaje;
  const _MensajeError({required this.mensaje});

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
          Expanded(child: Text(mensaje, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
        ],
      ),
    );
  }
}

class _BotonPrincipal extends StatelessWidget {
  final String etiqueta;
  final bool cargando;
  final VoidCallback alPresionar;

  const _BotonPrincipal({required this.etiqueta, required this.cargando, required this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFC026D3)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.45), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: cargando ? null : alPresionar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: cargando
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(etiqueta, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}