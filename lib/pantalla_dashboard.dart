import 'package:flutter/material.dart';
import 'pantalla_ruta_aprendizaje.dart';
import 'pantalla_perfil.dart';
import 'pantalla_juego.dart';

// ─────────────────────────────────────────────
//  Pantalla Dashboard Principal
// ─────────────────────────────────────────────
class PantallaDashboard extends StatefulWidget {
  const PantallaDashboard({super.key});

  @override
  State<PantallaDashboard> createState() => _EstadoPantallaDashboard();
}

class _EstadoPantallaDashboard extends State<PantallaDashboard>
    with SingleTickerProviderStateMixin {
  final _controladorBusqueda = TextEditingController();
  late AnimationController _controladorAnimacion;

  final int _puntajeActual = 1247;
  final int _nivelActual = 12;
  final String _nombreEstudiante = 'PyJugador';

  double _posicionPajaro = 0.0;
  bool _pajaroSubiendo = false;

  @override
  void initState() {
    super.initState();
    _controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        setState(() {
          if (_pajaroSubiendo) {
            _posicionPajaro = -30 * _controladorAnimacion.value;
          } else {
            _posicionPajaro = 30 * _controladorAnimacion.value;
          }
        });
      })
      ..addStatusListener((estado) {
        if (estado == AnimationStatus.completed) {
          _pajaroSubiendo = !_pajaroSubiendo;
          _controladorAnimacion.reset();
          _controladorAnimacion.forward();
        }
      });
    _controladorAnimacion.forward();
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    _controladorAnimacion.dispose();
    super.dispose();
  }

  void _alPresionarOpcion(String nombreOpcion) {
    switch (nombreOpcion) {
      case 'Iniciar Desafío':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PantallaJuegoFlappy()),
        );
        break;
      case 'Ruta de Aprendizaje':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PantallaRutaAprendizaje()),
        );
        break;
      case 'Mi Perfil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PantallaPerfil()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🚧 "$nombreOpcion" estará disponible pronto'),
            backgroundColor: const Color(0xFF7C3AED),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
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
            _BarraSuperior(controladorBusqueda: _controladorBusqueda),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth;
                  final esMovil = ancho < 600;
                  final paddingVertical = esMovil ? 16.0 : 28.0;
                  final paddingHorizontal = esMovil ? 16.0 : 24.0;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                      vertical: paddingVertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TituloPrincipal(
                          nombreEstudiante: _nombreEstudiante,
                          anchoPantalla: ancho,
                        ),
                        const SizedBox(height: 32),
                        LayoutBuilder(
                          builder: (ctx, restricciones) {
                            final esAncho = restricciones.maxWidth > 700;
                            if (esAncho) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _GrillaOpciones(
                                      alPresionar: _alPresionarOpcion,
                                      anchoPantalla: ancho,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  SizedBox(
                                    width: 280,
                                    child: _TarjetaDesafioActual(
                                      posicionPajaro: _posicionPajaro,
                                      puntaje: _puntajeActual,
                                      nivel: _nivelActual,
                                      alIniciarJuego: () => _alPresionarOpcion('Iniciar Desafío'),
                                      anchoPantalla: ancho,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                _GrillaOpciones(
                                  alPresionar: _alPresionarOpcion,
                                  anchoPantalla: ancho,
                                ),
                                const SizedBox(height: 24),
                                _TarjetaDesafioActual(
                                  posicionPajaro: _posicionPajaro,
                                  puntaje: _puntajeActual,
                                  nivel: _nivelActual,
                                  alIniciarJuego: () => _alPresionarOpcion('Iniciar Desafío'),
                                  anchoPantalla: ancho,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Barra superior con búsqueda y compartir (responsiva)
// ─────────────────────────────────────────────
class _BarraSuperior extends StatelessWidget {
  final TextEditingController controladorBusqueda;
  const _BarraSuperior({required this.controladorBusqueda});

  @override
  Widget build(BuildContext contexto) {
    final ancho = MediaQuery.of(contexto).size.width;
    final esMovil = ancho < 600;
    final fontSizeTexto = esMovil ? 10.0 : 13.0;
    final paddingHorizontal = esMovil ? 12.0 : 20.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 12),
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
          Flexible(
            child: Text(
              'PGC: Plataforma Gamificada de Codificación Python',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: fontSizeTexto,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controladorBusqueda,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar cursos, lecciones, proyectos...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7C3AED)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, color: Colors.white, size: 16),
              label: const Text(
                'Compartir',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Título principal con subtítulo (responsivo)
// ─────────────────────────────────────────────
class _TituloPrincipal extends StatelessWidget {
  final String nombreEstudiante;
  final double anchoPantalla;

  const _TituloPrincipal({
    required this.nombreEstudiante,
    required this.anchoPantalla,
  });

  double _getTituloFontSize() {
    if (anchoPantalla >= 900) return 36;
    if (anchoPantalla >= 600) return 28;
    return 24;
  }

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PGC: Plataforma de Codificación Python',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTituloFontSize(),
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: 'Ecosistema Educativo | Estilo Flappy Bird',
                style: TextStyle(color: Color(0xFFF59E0B)),
              ),
              TextSpan(
                text: ' • Aprende Codificando',
                style: TextStyle(color: Color(0xFFF59E0B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Modelo de opción del menú
// ─────────────────────────────────────────────
class _OpcionMenu {
  final IconData icono;
  final String etiqueta;

  const _OpcionMenu({required this.icono, required this.etiqueta});
}

// ─────────────────────────────────────────────
//  Grilla de opciones (columnas responsivas)
// ─────────────────────────────────────────────
class _GrillaOpciones extends StatelessWidget {
  final void Function(String) alPresionar;
  final double anchoPantalla;

  const _GrillaOpciones({
    required this.alPresionar,
    required this.anchoPantalla,
  });

  static const List<_OpcionMenu> _opciones = [
    _OpcionMenu(icono: Icons.play_arrow_rounded,      etiqueta: 'Iniciar Desafío'),
    _OpcionMenu(icono: Icons.menu_book_rounded,        etiqueta: 'Ruta de Aprendizaje'),
    _OpcionMenu(icono: Icons.person_outline_rounded,   etiqueta: 'Mi Perfil'),
    _OpcionMenu(icono: Icons.emoji_events_outlined,    etiqueta: 'Clasificación Global'),
    _OpcionMenu(icono: Icons.military_tech_outlined,   etiqueta: 'Mis Logros y Medallas'),
    _OpcionMenu(icono: Icons.settings_outlined,        etiqueta: 'Configuración de Cuenta'),
    _OpcionMenu(icono: Icons.code_rounded,             etiqueta: 'Editor de Código Sandbox'),
    _OpcionMenu(icono: Icons.calendar_today_outlined,  etiqueta: 'Lecciones Diarias'),
    _OpcionMenu(icono: Icons.group_outlined,           etiqueta: 'Proyectos de la Comunidad'),
    _OpcionMenu(icono: Icons.help_outline_rounded,     etiqueta: 'Soporte Técnico / Ayuda'),
  ];

  int _getCrossAxisCount() {
    if (anchoPantalla >= 900) return 5;
    if (anchoPantalla >= 600) return 4;
    return 2;
  }

  double _getCrossAxisSpacing() {
    return anchoPantalla < 600 ? 10 : 14;
  }

  double _getMainAxisSpacing() {
    return anchoPantalla < 600 ? 10 : 14;
  }

  @override
  Widget build(BuildContext contexto) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        crossAxisSpacing: _getCrossAxisSpacing(),
        mainAxisSpacing: _getMainAxisSpacing(),
        childAspectRatio: 1.1,
      ),
      itemCount: _opciones.length,
      itemBuilder: (ctx, indice) {
        final opcion = _opciones[indice];
        return _TarjetaOpcion(
          icono: opcion.icono,
          etiqueta: opcion.etiqueta,
          alPresionar: () => alPresionar(opcion.etiqueta),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Tarjeta individual de opción (sin cambios)
// ─────────────────────────────────────────────
class _TarjetaOpcion extends StatefulWidget {
  final IconData icono;
  final String etiqueta;
  final VoidCallback alPresionar;

  const _TarjetaOpcion({
    required this.icono,
    required this.etiqueta,
    required this.alPresionar,
  });

  @override
  State<_TarjetaOpcion> createState() => _EstadoTarjetaOpcion();
}

class _EstadoTarjetaOpcion extends State<_TarjetaOpcion> {
  bool _hovering = false;

  @override
  Widget build(BuildContext contexto) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.alPresionar,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovering
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovering
                  ? const Color(0xFF7C3AED)
                  : Colors.white.withValues(alpha: 0.15),
              width: _hovering ? 1.5 : 1,
            ),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icono, color: Colors.white, size: 32),
              const SizedBox(height: 10),
              Text(
                widget.etiqueta,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tarjeta Desafío Actual (con altura responsiva)
// ─────────────────────────────────────────────
class _TarjetaDesafioActual extends StatelessWidget {
  final double posicionPajaro;
  final int puntaje;
  final int nivel;
  final VoidCallback alIniciarJuego;
  final double anchoPantalla;

  const _TarjetaDesafioActual({
    required this.posicionPajaro,
    required this.puntaje,
    required this.nivel,
    required this.alIniciarJuego,
    required this.anchoPantalla,
  });

  double _getGameAreaHeight() {
    return anchoPantalla < 600 ? 180 : 220;
  }

  @override
  Widget build(BuildContext contexto) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              'Desafío Actual',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // Área del juego con botón de play
          GestureDetector(
            onTap: alIniciarJuego,
            child: Container(
              height: _getGameAreaHeight(),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF87CEEB),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // Suelo
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(height: 30, color: const Color(0xFF4CAF50)),
                  ),
                  // Tubo superior izquierdo
                  Positioned(
                    top: 0, left: 30,
                    child: Container(
                      width: 40, height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF388E3C),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Tubo inferior izquierdo
                  Positioned(
                    bottom: 30, left: 30,
                    child: Container(width: 40, height: 60, color: const Color(0xFF388E3C)),
                  ),
                  // Tubo superior derecho
                  Positioned(
                    top: 0, right: 30,
                    child: Container(
                      width: 40, height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF388E3C),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Tubo inferior derecho
                  Positioned(
                    bottom: 30, right: 30,
                    child: Container(width: 40, height: 80, color: const Color(0xFF388E3C)),
                  ),
                  // Etiqueta Python
                  Positioned(
                    top: 80, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '</> Python',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  // Pájaro animado
                  Positioned(
                    top: 90 + posicionPajaro,
                    left: 100,
                    child: const _PajaroFlappy(),
                  ),
                  // Botón play encima
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54, width: 2),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _TarjetaStat(
                    etiqueta: 'Puntaje Actual',
                    valor: puntaje.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TarjetaStat(etiqueta: 'Nivel', valor: nivel.toString()),
                ),
              ],
            ),
          ),

          // Botón jugar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: alIniciarJuego,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                label: const Text('¡Jugar Ahora!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF61B1B),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Pájaro Flappy Bird (sin cambios)
// ─────────────────────────────────────────────
class _PajaroFlappy extends StatelessWidget {
  const _PajaroFlappy();

  @override
  Widget build(BuildContext contexto) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        children: [
          Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA726),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: Container(
              width: 14, height: 14,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 11, right: 10,
            child: Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 20, right: 0,
            child: Container(
              width: 12, height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F00),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tarjeta de estadística (sin cambios)
// ─────────────────────────────────────────────
class _TarjetaStat extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _TarjetaStat({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}