import 'package:flutter/material.dart';
import 'sesion_usuario.dart';
import 'servicio_api.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _EstadoPantallaPerfil();
}

class _EstadoPantallaPerfil extends State<PantallaPerfil> {
  bool _cargando = true;
  String _nombre = '';
  String _correo = '';
  int _highscore = 0;
  int _totalPartidas = 0;
  List<Map<String, dynamic>> _historial = [];

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    setState(() => _cargando = true);

    final resultado = await ServicioApi.obtenerPerfil(
      correo: SesionUsuario.correo,
    );

    if (!mounted) return;

    if (resultado.exito && resultado.usuario != null) {
      setState(() {
        _nombre = resultado.usuario!['nombre'] ?? SesionUsuario.nombre;
        _correo = resultado.usuario!['correo'] ?? SesionUsuario.correo;
        _highscore = resultado.usuario!['highscore'] ?? 0;
        _totalPartidas = resultado.usuario!['total_partidas'] ?? 0;
        _historial = List<Map<String, dynamic>>.from(
          resultado.usuario!['historial'] ?? [],
        );
        _cargando = false;
      });
    } else {
      // Si falla el backend usar datos de sesión
      setState(() {
        _nombre = SesionUsuario.nombre;
        _correo = SesionUsuario.correo;
        _cargando = false;
      });
    }
  }

  // Iniciales del nombre para el avatar
  String get _iniciales {
    if (_nombre.isEmpty) return '??';
    final partes = _nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return _nombre.substring(0, _nombre.length >= 2 ? 2 : 1).toUpperCase();
  }

  void _cerrarSesion() {
    SesionUsuario.cerrar();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            label: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  // ── Avatar e Info ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // Avatar con iniciales
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF59E0B), width: 4),
                            color: const Color(0xFF2563EB),
                          ),
                          child: Center(
                            child: Text(
                              _iniciales,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nombre
                        Text(
                          _nombre.isEmpty ? 'Sin nombre' : _nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Correo
                        Text(
                          _correo,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // User ID (correo como identificador)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Correo registrado',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _correo,
                                style: const TextStyle(
                                  color: Color(0xFFF59E0B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Estadísticas ──
                  _TarjetaEstadistica(
                    titulo: 'Highscore',
                    valor: '$_highscore pts',
                    progreso: _highscore > 0 ? (_highscore / 20).clamp(0.0, 1.0) : 0,
                    color: const Color(0xFF2563EB),
                    icono: Icons.emoji_events,
                  ),
                  _TarjetaEstadistica(
                    titulo: 'Total de Partidas',
                    valor: '$_totalPartidas',
                    progreso: _totalPartidas > 0 ? (_totalPartidas / 50).clamp(0.0, 1.0) : 0,
                    color: const Color(0xFF16A34A),
                    icono: Icons.sports_esports,
                  ),

                  // ── Historial de partidas ──
                  if (_historial.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📋 Últimas Partidas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._historial.map((p) => _FilaPartida(partida: p)),
                        ],
                      ),
                    ),
                  ],

                  // Botón recargar
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _cargarPerfil,
                      icon: const Icon(Icons.refresh, color: Color(0xFFF59E0B)),
                      label: const Text(
                        'Actualizar datos',
                        style: TextStyle(color: Color(0xFFF59E0B)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF59E0B)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

// ── Fila de historial de partida ──
class _FilaPartida extends StatelessWidget {
  final Map<String, dynamic> partida;
  const _FilaPartida({required this.partida});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sports_esports, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${partida['puntaje']} puntos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '✅ ${partida['preguntas_correctas']}  ❌ ${partida['preguntas_incorrectas']}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            partida['fecha'] ?? '',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de estadística ──
class _TarjetaEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final double progreso;
  final Color color;
  final IconData icono;

  const _TarjetaEstadistica({
    required this.titulo,
    required this.valor,
    required this.progreso,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icono, color: Colors.white.withValues(alpha: 0.8), size: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    valor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Colors.black.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
        ],
      ),
    );
  }
}