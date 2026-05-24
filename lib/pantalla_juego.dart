import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'servicio_api.dart';
import 'sesion_usuario.dart';

// ─────────────────────────────────────────────
//  CONSTANTES DEL JUEGO
// ─────────────────────────────────────────────
const double gravedad = 0.5;
const double impulsoSalto = -7.0;
const double anchoPajaro = 30.0;
const double altoPajaro = 30.0;
const double anchoTuberia = 60.0;

// ─────────────────────────────────────────────
//  PREGUNTAS DE PYTHON
// ─────────────────────────────────────────────
const List<Map<String, dynamic>> preguntasFacil = [
  {"pregunta": "¿Qué palabra clave se usa para definir una función en Python?", "opciones": ["class", "def", "func", "define"], "respuesta": "def"},
  {"pregunta": "¿Qué tipo de dato almacena números enteros?", "opciones": ["float", "str", "int", "bool"], "respuesta": "int"},
  {"pregunta": "¿Cuál es el resultado de '5' + '5' en Python?", "opciones": ["10", "55", "Error", "5+5"], "respuesta": "55"},
  {"pregunta": "¿Qué operador calcula el módulo (resto de la división)?", "opciones": ["//", "**", "%", "/"], "respuesta": "%"},
  {"pregunta": "¿Qué función muestra información en pantalla?", "opciones": ["echo()", "write()", "print()", "show()"], "respuesta": "print()"},
  {"pregunta": "¿Qué símbolo comenta una línea en Python?", "opciones": ["//", "#", "/*", "--"], "respuesta": "#"},
  {"pregunta": "¿Qué tipo de dato almacena palabras?", "opciones": ["float", "str", "int", "bool"], "respuesta": "str"},
  {"pregunta": "¿Qué estructura ejecuta código solo si se cumple una condición?", "opciones": ["while", "if", "for", "def"], "respuesta": "if"},
  {"pregunta": "¿Qué palabra clave importa módulos en Python?", "opciones": ["include", "require", "import", "using"], "respuesta": "import"},
  {"pregunta": "¿Qué imprime print(2 ** 3)?", "opciones": ["6", "8", "9", "Error"], "respuesta": "8"},
  {"pregunta": "¿Qué palabra clave finaliza un bucle antes de tiempo?", "opciones": ["continue", "stop", "end", "break"], "respuesta": "break"},
  {"pregunta": "¿Qué método convierte una cadena a minúsculas?", "opciones": ["lower()", "downcase()", "small()", "toLower()"], "respuesta": "lower()"},
  {"pregunta": "¿Qué imprime print('Hola' * 3)?", "opciones": ["HolaHolaHola", "Error", "Hola3", "'Hola'*3"], "respuesta": "HolaHolaHola"},
  {"pregunta": "¿Qué función devuelve la longitud de una lista?", "opciones": ["count()", "len()", "size()", "length()"], "respuesta": "len()"},
  {"pregunta": "¿Qué palabra clave devuelve un valor desde una función?", "opciones": ["send", "output", "return", "yield"], "respuesta": "return"},
];

const List<Map<String, dynamic>> preguntasIntermedio = [
  {"pregunta": "¿Qué palabra clave define una clase en Python?", "opciones": ["define", "object", "class", "struct"], "respuesta": "class"},
  {"pregunta": "¿Qué operador lógico representa 'y' en Python?", "opciones": ["&", "&&", "and", "plus"], "respuesta": "and"},
  {"pregunta": "¿Qué devuelve la expresión 10 // 3?", "opciones": ["3.33", "3", "4", "Error"], "respuesta": "3"},
  {"pregunta": "¿Qué valor lógico devuelve (5 > 2 and 2 < 1)?", "opciones": ["True", "False", "Error", "None"], "respuesta": "False"},
  {"pregunta": "¿Qué método agrega un elemento al final de una lista?", "opciones": ["add()", "append()", "insert()", "push()"], "respuesta": "append()"},
  {"pregunta": "¿Qué tipo de dato devuelve input()?", "opciones": ["int", "str", "float", "bool"], "respuesta": "str"},
  {"pregunta": "¿Qué función convierte una cadena en número entero?", "opciones": ["str()", "int()", "float()", "eval()"], "respuesta": "int()"},
  {"pregunta": "¿Qué operador compara igualdad?", "opciones": ["=", "==", "!=", "==="], "respuesta": "=="},
  {"pregunta": "¿Qué estructura de datos no permite duplicados?", "opciones": ["list", "tuple", "set", "dict"], "respuesta": "set"},
  {"pregunta": "¿Cuál es el índice del primer elemento en una lista?", "opciones": ["0", "1", "-1", "Depende"], "respuesta": "0"},
  {"pregunta": "¿Qué método elimina el último elemento de una lista?", "opciones": ["delete()", "remove()", "pop()", "clear()"], "respuesta": "pop()"},
  {"pregunta": "¿Qué función devuelve el valor máximo de una lista?", "opciones": ["max()", "high()", "top()", "max_value()"], "respuesta": "max()"},
  {"pregunta": "¿Qué imprime print(len('Python'))?", "opciones": ["6", "7", "5", "Error"], "respuesta": "6"},
];

const List<Map<String, dynamic>> preguntasAvanzado = [
  {"pregunta": "¿Qué palabra clave define una función anónima?", "opciones": ["lambda", "anon", "func", "temp"], "respuesta": "lambda"},
  {"pregunta": "¿Cuál estructura de datos es inmutable?", "opciones": ["list", "tuple", "set", "dict"], "respuesta": "tuple"},
  {"pregunta": "¿Qué error ocurre al acceder a una clave inexistente en un diccionario?", "opciones": ["KeyError", "ValueError", "IndexError", "TypeError"], "respuesta": "KeyError"},
  {"pregunta": "¿Qué imprime print([x**2 for x in range(3)])?", "opciones": ["[1,2,3]", "[0, 1, 4]", "[1,4,9]", "Error"], "respuesta": "[0, 1, 4]"},
  {"pregunta": "¿Qué instrucción crea un conjunto vacío?", "opciones": ["{}", "[]", "set()", "empty_set()"], "respuesta": "set()"},
  {"pregunta": "¿Qué hace enumerate() en un bucle for?", "opciones": ["Devuelve índices y valores", "Cuenta elementos", "Concatena listas", "Itera al revés"], "respuesta": "Devuelve índices y valores"},
  {"pregunta": "¿Qué imprime print(sum([1,2,3,4]))?", "opciones": ["10", "1234", "Error", "6"], "respuesta": "10"},
  {"pregunta": "¿Qué palabra clave crea un generador?", "opciones": ["yield", "generate", "return", "next"], "respuesta": "yield"},
  {"pregunta": "¿Qué error ocurre al dividir entre cero?", "opciones": ["ZeroDivisionError", "ArithmeticError", "TypeError", "ValueError"], "respuesta": "ZeroDivisionError"},
];

Map<String, dynamic> obtenerPregunta(int puntuacion) {
  List<Map<String, dynamic>> pool;
  if (puntuacion < 5) {
    pool = preguntasFacil;
  } else if (puntuacion < 10) {
    pool = preguntasIntermedio;
  } else {
    pool = preguntasAvanzado;
  }
  final r = Random();
  final pregunta = Map<String, dynamic>.from(pool[r.nextInt(pool.length)]);
  final opciones = List<String>.from(pregunta['opciones'])..shuffle(r);
  pregunta['opciones'] = opciones;
  return pregunta;
}

// ─────────────────────────────────────────────
//  MODELO DE TUBERÍA
// ─────────────────────────────────────────────
class Tuberia {
  double x;
  final double huecoSuperior;
  final double huecoInferior;
  bool puntuada;

  Tuberia({
    required this.x,
    required this.huecoSuperior,
    required this.huecoInferior,
    this.puntuada = false,
  });
}

// ─────────────────────────────────────────────
//  PANTALLA PRINCIPAL DEL JUEGO
// ─────────────────────────────────────────────
class PantallaJuegoFlappy extends StatefulWidget {
  const PantallaJuegoFlappy({super.key});

  @override
  State<PantallaJuegoFlappy> createState() => _PantallaJuegoFlappyState();
}

class _PantallaJuegoFlappyState extends State<PantallaJuegoFlappy> {
  // ── Estado del juego ──
  bool _juegoIniciado = false;
  bool _enMenu = true;
  bool _gameOver = false;
  String _dificultad = 'facil';

  // ── Pájaro ──
  double _pajaroY = 300;
  double _velocidadY = 0;

  // ── Tuberías ──
  List<Tuberia> _tuberias = [];

  // ── Stats ──
  int _puntuacion = 0;
  int _vidas = 2;
  int _preguntasCorrectas = 0;
  int _preguntasIncorrectas = 0;

  // ── Contador de pausa post-quiz ──
  int _cuentaRegresiva = 0;

  // ── Posición de reaparecer ──
  double _posicionRespawn = 300.0;

  // ── Config dificultad ──
  double _velocidadTuberia = 3.0;
  double _huecoTuberia = 160.0;

  // ── Timer ──
  Timer? _timer;
  double _contadorTuberia = 0;

  // ── Tamaño de pantalla ──
  double _ancho = 400;
  double _alto = 700;

  final Random _random = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _aplicarDificultad() {
    if (_dificultad == 'facil') {
      _velocidadTuberia = 3.0;
      _huecoTuberia = 160.0;
      _vidas = 2;
    } else {
      _velocidadTuberia = 5.0;
      _huecoTuberia = 120.0;
      _vidas = 1;
    }
  }

  void _iniciarJuego() {
    _aplicarDificultad();
    setState(() {
      _enMenu = false;
      _juegoIniciado = true;
      _gameOver = false;
      _puntuacion = 0;
      _preguntasCorrectas = 0;
      _preguntasIncorrectas = 0;
      _pajaroY = _alto / 2;
      _velocidadY = 0;
      _tuberias = [];
      _contadorTuberia = 0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _actualizarJuego();
    });
  }

  void _saltar() {
    if (_juegoIniciado) {
      setState(() => _velocidadY = impulsoSalto);
    }
  }

  void _actualizarJuego() {
    if (!_juegoIniciado) return;

    setState(() {
      // Gravedad
      _velocidadY += gravedad;
      _pajaroY += _velocidadY;

      // Límites techo/suelo
      final suelo = _alto - 80;
      if (_pajaroY < 15) {
        _pajaroY = 15;
        _posicionRespawn = _alto / 2; // centro de pantalla
        _perderVida();
        return;
      }
      if (_pajaroY > suelo - 15) {
        _pajaroY = suelo - 15;
        _posicionRespawn = _alto / 2; // centro de pantalla
        _perderVida();
        return;
      }

      // Mover tuberías
      _contadorTuberia += _velocidadTuberia;
      for (final t in _tuberias) {
        t.x -= _velocidadTuberia;
      }

      // Nueva tubería cada ~200px
      if (_contadorTuberia > 220) {
        _contadorTuberia = 0;
        _crearTuberia();
      }

      // Eliminar tuberías fuera de pantalla
      _tuberias.removeWhere((t) => t.x < -anchoTuberia - 10);

      // Puntuación
      for (final t in _tuberias) {
        if (!t.puntuada && t.x + anchoTuberia < 100) {
          t.puntuada = true;
          _puntuacion++;
        }
      }

      // Colisión con tuberías
      _verificarColision();
    });
  }

  void _crearTuberia() {
    final centro = 150 + _random.nextInt((_alto - 300).toInt());
    _tuberias.add(Tuberia(
      x: _ancho + 10,
      huecoSuperior: centro.toDouble() - _huecoTuberia / 2,
      huecoInferior: centro.toDouble() + _huecoTuberia / 2,
    ));
  }

  void _verificarColision() {
    const pajaroX = 100.0;
    const radio = anchoPajaro / 2;

    for (final t in _tuberias) {
      final dentroDeltaX = pajaroX + radio > t.x && pajaroX - radio < t.x + anchoTuberia;
      if (dentroDeltaX) {
        if (_pajaroY - radio < t.huecoSuperior || _pajaroY + radio > t.huecoInferior) {
          // Guardar el centro del hueco de esta tubería para el respawn
          _posicionRespawn = (t.huecoSuperior + t.huecoInferior) / 2;
          _perderVida();
          return;
        }
      }
    }
  }

  void _perderVida() {
    _vidas--;
    if (_vidas <= 0) {
      _timer?.cancel();
      _juegoIniciado = false;
      Future.microtask(() => _mostrarQuiz());
    } else {
      _velocidadY = 0;
    }
  }

  void _mostrarQuiz() {
    final pregunta = obtenerPregunta(_puntuacion);
    String? seleccionada;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF1E90FF)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚠️ ¡ÚLTIMA OPORTUNIDAD!',
                    style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Responde correctamente para ganar 1 vida',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pregunta['pregunta'],
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ...(pregunta['opciones'] as List<String>).map((op) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => setModal(() => seleccionada = op),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: seleccionada == op
                            ? const Color(0xFF7C3AED)
                            : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: seleccionada == op ? Colors.white : Colors.white24,
                        ),
                      ),
                      child: Text(op,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center),
                    ),
                  ),
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: seleccionada == null
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            _manejarRespuestaQuiz(seleccionada!, pregunta['respuesta']);
                          },
                    child: const Text('Responder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _manejarRespuestaQuiz(String seleccionada, String correcta) {
    if (seleccionada == correcta) {
      _preguntasCorrectas++;
      setState(() {
        _vidas = 1;
        _pajaroY = _posicionRespawn;
        _velocidadY = 0;
        _cuentaRegresiva = 4;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ ¡Correcto! +1 vida. ¡Sigue volando!'),
          backgroundColor: Color(0xFF16A34A),
          duration: Duration(seconds: 1),
        ),
      );
      // Contador regresivo cada segundo
      Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) { t.cancel(); return; }
        setState(() => _cuentaRegresiva--);
        if (_cuentaRegresiva <= 0) {
          t.cancel();
          setState(() => _juegoIniciado = true);
          _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
            _actualizarJuego();
          });
        }
      });
    } else {
      _preguntasIncorrectas++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Incorrecto. La respuesta era: $correcta'),
          backgroundColor: Colors.red,
        ),
      );
      _finJuego();
    }
  }

  Future<void> _finJuego() async {
    _timer?.cancel();
    setState(() {
      _juegoIniciado = false;
      _gameOver = true;
    });

    // Guardar en Django si hay sesión activa
    if (SesionUsuario.activa) {
      await ServicioApi.guardarPartida(
        correo: SesionUsuario.correo,
        puntaje: _puntuacion,
        preguntasCorrectas: _preguntasCorrectas,
        preguntasIncorrectas: _preguntasIncorrectas,
      );
    }

    if (!mounted) return;
    _mostrarGameOver();
  }

  void _mostrarGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D0A6B), Color(0xFF7B2FF7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💀 GAME OVER', style: TextStyle(color: Color(0xFFFFD700), fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              _filaStat('🏆 Puntuación', '$_puntuacion'),
              _filaStat('✅ Correctas', '$_preguntasCorrectas'),
              _filaStat('❌ Incorrectas', '$_preguntasIncorrectas'),
              _filaStat('🎮 Dificultad', _dificultad == 'facil' ? 'Fácil' : 'Difícil'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _iniciarJuego();
                      },
                      child: const Text('🔄 Reintentar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _enMenu = true);
                      },
                      child: const Text('🏠 Menú', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filaStat(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _mostrarInstrucciones() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF483D8B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('¿Cómo Jugar?',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 16),
              ...[
                '🎮 Toca la pantalla para que el pájaro salte',
                '🚧 Pasa entre las tuberías sin tocarlas',
                '❤️ Tienes vidas según la dificultad elegida',
                '❓ Si pierdes todas las vidas, aparece un quiz',
                '💚 Responde bien para ganar 1 vida y continuar',
                '🏆 Tu puntaje se guarda en la base de datos',
              ].map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(e, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32CD32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Entendido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD PRINCIPAL
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    _ancho = MediaQuery.of(context).size.width;
    _alto = MediaQuery.of(context).size.height;

    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            _saltar();
          }
        },
        child: GestureDetector(
          onTap: _saltar,
          child: _enMenu ? _buildMenu() : _buildJuego(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  MENÚ PRINCIPAL (estilo login)
  // ─────────────────────────────────────────────
  Widget _buildMenu() {
    return Container(
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
          // ── Barra superior estilo login ──
          Container(
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
                const Spacer(),
                // Botón volver
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Contenido centrado ──
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pájaro
                        _buildPajaroAnimado(),
                        const SizedBox(height: 24),

                        // Título
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                            children: [
                              TextSpan(text: '¡Vuela, ', style: TextStyle(color: Colors.white)),
                              TextSpan(text: 'PyJugador!', style: TextStyle(color: Color(0xFFF59E0B))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Responde preguntas y sigue volando',
                          style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Selector dificultad
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Selecciona la Dificultad',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _botonDificultad('🟢  Fácil', 'facil', const Color(0xFF16A34A))),
                            const SizedBox(width: 12),
                            Expanded(child: _botonDificultad('🔴  Difícil', 'dificil', const Color(0xFFB21CDC))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            _dificultad == 'facil'
                                ? '⚡ Velocidad lenta  •  🕳️ Huecos amplios  •  ❤️ 2 vidas'
                                : '⚡ Velocidad rápida  •  🕳️ Huecos reducidos  •  ❤️ 1 vida',
                            style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Botón instrucciones
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _mostrarInstrucciones,
                            icon: const Icon(Icons.help_outline, color: Colors.white70, size: 18),
                            label: const Text(
                              '¿Cómo Jugar?',
                              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Botón iniciar juego
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFFC026D3)],
                              ),
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
                              onPressed: _mostrarConfirmacion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                '🚀  Iniciar Juego',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
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
    );
  }

  Widget _botonDificultad(String texto, String valor, Color color) {
    final seleccionado = _dificultad == valor;
    return GestureDetector(
      onTap: () => setState(() => _dificultad = valor),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: seleccionado ? color : Colors.white30,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: seleccionado ? Colors.white : Colors.transparent, width: 2),
          boxShadow: seleccionado ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10)] : [],
        ),
        child: Text(texto,
            style: TextStyle(
              color: Colors.white,
              fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            )),
      ),
    );
  }

  Widget _buildPajaroAnimado() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD700),
        border: Border.all(color: const Color(0xFFFF8C00), width: 3),
        boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.5), blurRadius: 20)],
      ),
      child: const Center(
        child: Text('🐦', style: TextStyle(fontSize: 40)),
      ),
    );
  }

  void _mostrarConfirmacion() {
    final cfg = _dificultad == 'facil'
        ? 'Velocidad: Lenta\nVidas: 2\nHueco: Amplio'
        : 'Velocidad: Rápida\nVidas: 1\nHueco: Reducido';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D0A6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Iniciar Juego', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          '¿Jugar en dificultad ${_dificultad == "facil" ? "FÁCIL" : "DIFÍCIL"}?\n\n$cfg',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF61B1B)),
            onPressed: () {
              Navigator.pop(ctx);
              _iniciarJuego();
            },
            child: const Text('¡Jugar!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  PANTALLA DE JUEGO
  // ─────────────────────────────────────────────
  Widget _buildJuego() {
    return Stack(
      children: [
        // Fondo cielo
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF87CEEB), Color(0xFF4A90D9), Color(0xFF38FA38)],
              stops: [0.0, 0.85, 0.85],
            ),
          ),
        ),

        // Tuberías
        ..._tuberias.map((t) => _buildTuberia(t)),

        // Pájaro
        Positioned(
          left: 100 - anchoPajaro / 2,
          top: _pajaroY - altoPajaro / 2,
          child: Container(
            width: anchoPajaro,
            height: altoPajaro,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD700),
              border: Border.all(color: const Color(0xFFFF8C00), width: 2),
              boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.5), blurRadius: 8)],
            ),
            child: const Center(child: Text('🐦', style: TextStyle(fontSize: 16))),
          ),
        ),

        // HUD - Vidas
        Positioned(
          top: 40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '❤️ x $_vidas',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // HUD - Puntuación
        Positioned(
          top: 40,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🏆 $_puntuacion',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Botón volver
        Positioned(
          top: 40,
          left: _ancho / 2 - 30,
          child: GestureDetector(
            onTap: () {
              _timer?.cancel();
              setState(() => _enMenu = true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('🏠', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),

        // Hint tap
        if (!_juegoIniciado && !_gameOver)
          const Center(
            child: Text('Toca para saltar', style: TextStyle(color: Colors.white70, fontSize: 18)),
          ),

        // Contador regresivo post-quiz
        if (_cuentaRegresiva > 0)
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF59E0B), width: 4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_cuentaRegresiva',
                    style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTuberia(Tuberia t) {
    return Stack(
      children: [
        // Tubería superior
        Positioned(
          left: t.x,
          top: 0,
          child: Container(
            width: anchoTuberia,
            height: t.huecoSuperior,
            decoration: BoxDecoration(
              color: const Color(0xFF228B22),
              border: Border.all(color: const Color(0xFF006400), width: 2),
            ),
          ),
        ),
        // Borde superior
        Positioned(
          left: t.x - 5,
          top: t.huecoSuperior - 20,
          child: Container(
            width: anchoTuberia + 10,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF32CD32),
              border: Border.all(color: const Color(0xFF006400), width: 2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
        ),
        // Tubería inferior
        Positioned(
          left: t.x,
          top: t.huecoInferior,
          child: Container(
            width: anchoTuberia,
            height: _alto - t.huecoInferior,
            decoration: BoxDecoration(
              color: const Color(0xFF228B22),
              border: Border.all(color: const Color(0xFF006400), width: 2),
            ),
          ),
        ),
        // Borde inferior
        Positioned(
          left: t.x - 5,
          top: t.huecoInferior,
          child: Container(
            width: anchoTuberia + 10,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF32CD32),
              border: Border.all(color: const Color(0xFF006400), width: 2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}