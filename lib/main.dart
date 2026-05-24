import 'package:flutter/material.dart';
import 'pantalla_inicio_sesion.dart';
 
void main() {
  runApp(const AplicacionPGC());
}
 
class AplicacionPGC extends StatelessWidget {
  const AplicacionPGC({super.key});
 
  @override
  Widget build(BuildContext contexto) {
    return MaterialApp(
      title: 'PGC - Inicio de Sesión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'sans-serif'),
      home: const PantallaInicioSesion(),

      routes: {
        '/login': (context) => const PantallaInicioSesion(),
      }
    );
  }
}
