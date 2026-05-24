import 'package:flutter/material.dart';

// --- MODELOS DE DATOS ---

class PreguntaNodo {
  final String enunciado;
  final List<String> opciones;
  final int respuestaCorrecta;

  const PreguntaNodo({
    required this.enunciado,
    required this.opciones,
    required this.respuestaCorrecta,
  });
}

enum EstadoNodo { completado, actual, bloqueado }

class NodoAprendizaje {
  final int numero;
  final String titulo;
  final IconData icono;
  final String contenido;
  final PreguntaNodo trivia;
  EstadoNodo estado;

  NodoAprendizaje({
    required this.numero,
    required this.titulo,
    required this.icono,
    required this.estado,
    required this.contenido,
    required this.trivia,
  });
}

// --- PANTALLA PRINCIPAL ---

class PantallaRutaAprendizaje extends StatefulWidget {
  const PantallaRutaAprendizaje({super.key});

  @override
  State<PantallaRutaAprendizaje> createState() => _PantallaRutaAprendizajeState();
}

class _PantallaRutaAprendizajeState extends State<PantallaRutaAprendizaje> {
  final List<NodoAprendizaje> _nodos = [
    // ── NODO 1: Variables ──────────────────────────────────────────────────
    NodoAprendizaje(
      numero: 1,
      titulo: 'Variables',
      icono: Icons.code,
      estado: EstadoNodo.actual,
      contenido:
          'Una variable es un espacio donde puedes guardar un dato para usarlo después. Es como ponerle una etiqueta a algo.\n'
          'nombre = "Juan"\n'
          'edad = 18\n'
          '\n'
          'Características de las variables en Python:\n'
          'No necesitas declarar el tipo (Python lo detecta solo)\n'
          'Son dinámicas: pueden cambiar de valor y tipo\n'
          'Sensibles a mayúsculas/minúsculas\n'
          '\n'
          'Tipos de datos comunes:\n'
          'Enteros (int)  → 10, 1\n'
          'Decimales (float) → 1.23\n'
          'Texto (str) → "Hola"\n'
          'Booleanos (bool) → True, False\n'
          '\n'
          'Reglas para nombrar variables:\n'
          'Pueden tener letras, números y _\n'
          'Deben empezar con letra o _\n'
          'No pueden empezar con número\n'
          'No usar palabras reservadas',
      trivia: const PreguntaNodo(
        enunciado: '¿Cuál es la forma correcta de declarar una variable de texto en Python?',
        opciones: ['a) string x = "Hola"', 'b) x = "Hola"', 'c) x := "Hola"'],
        respuestaCorrecta: 1,
      ),
    ),

    // ── NODO 2: Condicionales ──────────────────────────────────────────────
    NodoAprendizaje(
      numero: 2,
      titulo: 'Condicionales',
      icono: Icons.call_split_rounded,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Los condicionales permiten que tu programa tome decisiones según si una condición es verdadera o falsa.\n'
          '\n'
          'Palabras clave:\n'
          'if  → evalúa la condición principal\n'
          'elif → evalúa una segunda condición si la anterior fue falsa\n'
          'else → se ejecuta si ninguna condición anterior fue verdadera\n'
          '\n'
          'Ejemplo básico:\n'
          'edad = 18\n'
          'if edad >= 18:\n'
          '    print("Eres mayor de edad")\n'
          'elif edad >= 13:\n'
          '    print("Eres adolescente")\n'
          'else:\n'
          '    print("Eres niño")\n'
          '\n'
          'Operadores de comparación:\n'
          '==  igual a\n'
          '!=  diferente de\n'
          '>   mayor que\n'
          '<   menor que\n'
          '>=  mayor o igual\n'
          '<=  menor o igual\n'
          '\n'
          'Operadores lógicos:\n'
          'and → ambas condiciones deben ser True\n'
          'or  → al menos una debe ser True\n'
          'not → invierte el resultado\n'
          '\n'
          'Importante: La indentación (4 espacios) es obligatoria en Python.',
      trivia: const PreguntaNodo(
        enunciado: '¿Qué palabra se usa para evaluar una segunda condición si la primera es falsa?',
        opciones: ['a) else if', 'b) elseif', 'c) elif'],
        respuestaCorrecta: 2,
      ),
    ),

    // ── NODO 3: Bucles ────────────────────────────────────────────────────
    NodoAprendizaje(
      numero: 3,
      titulo: 'Bucles',
      icono: Icons.loop_rounded,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Un bucle repite un bloque de código varias veces. Python tiene dos tipos principales.\n'
          '\n'
          '── Bucle for ──\n'
          'Recorre cada elemento de una secuencia (lista, rango, texto).\n'
          'for i in range(5):\n'
          '    print(i)   # imprime 0, 1, 2, 3, 4\n'
          '\n'
          'Iterar sobre una lista:\n'
          'frutas = ["manzana", "pera", "uva"]\n'
          'for fruta in frutas:\n'
          '    print(fruta)\n'
          '\n'
          '── Bucle while ──\n'
          'Repite el código MIENTRAS una condición sea True.\n'
          'contador = 0\n'
          'while contador < 3:\n'
          '    print(contador)\n'
          '    contador += 1\n'
          '\n'
          'Funciones útiles con bucles:\n'
          'range(inicio, fin, paso) → genera una secuencia de números\n'
          'len(lista) → devuelve la cantidad de elementos\n'
          'enumerate(lista) → devuelve índice y valor a la vez\n'
          '\n'
          'Palabras de control:\n'
          'break    → detiene el bucle por completo\n'
          'continue → salta a la siguiente iteración\n'
          'pass     → no hace nada (marcador de posición)',
      trivia: const PreguntaNodo(
        enunciado: '¿Qué función genera una secuencia de números para un bucle for?',
        opciones: ['a) range()', 'b) sequence()', 'c) list()'],
        respuestaCorrecta: 0,
      ),
    ),

    // ── NODO 4: Listas ────────────────────────────────────────────────────
    NodoAprendizaje(
      numero: 4,
      titulo: 'Listas',
      icono: Icons.format_list_bulleted_rounded,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Una lista es una colección ordenada y mutable de elementos. Puede contener distintos tipos de datos.\n'
          '\n'
          'Crear una lista:\n'
          'frutas = ["manzana", "pera", "uva"]\n'
          'numeros = [1, 2, 3, 4, 5]\n'
          'mixta  = [1, "hola", True, 3.14]\n'
          '\n'
          'Acceder a elementos (índice empieza en 0):\n'
          'frutas[0]  → "manzana"\n'
          'frutas[-1] → "uva"  (último elemento)\n'
          '\n'
          'Métodos más usados:\n'
          '.append(x)    → agrega x al final\n'
          '.insert(i, x) → inserta x en la posición i\n'
          '.remove(x)    → elimina la primera aparición de x\n'
          '.pop()        → elimina y devuelve el último elemento\n'
          '.sort()       → ordena la lista (modifica el original)\n'
          '.reverse()    → invierte el orden\n'
          'len(lista)    → número de elementos\n'
          '\n'
          'Slicing (sublistas):\n'
          'frutas[1:3]  → ["pera", "uva"]\n'
          'frutas[:2]   → ["manzana", "pera"]\n'
          '\n'
          'Lista por comprensión (forma compacta):\n'
          'cuadrados = [x**2 for x in range(5)]\n'
          '# resultado: [0, 1, 4, 9, 16]',
      trivia: const PreguntaNodo(
        enunciado: '¿Con qué símbolo se definen las listas en Python?',
        opciones: ['a) Llaves { }', 'b) Paréntesis ( )', 'c) Corchetes [ ]'],
        respuestaCorrecta: 2,
      ),
    ),

    // ── NODO 5: Funciones ─────────────────────────────────────────────────
    NodoAprendizaje(
      numero: 5,
      titulo: 'Funciones',
      icono: Icons.data_object_rounded,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Una función es un bloque de código reutilizable que realiza una tarea específica. Se define una vez y se llama las veces que quieras.\n'
          '\n'
          'Definir una función:\n'
          'def saludar():\n'
          '    print("¡Hola, mundo!")\n'
          '\n'
          'Llamar la función:\n'
          'saludar()   # imprime: ¡Hola, mundo!\n'
          '\n'
          'Funciones con parámetros:\n'
          'def saludar(nombre):\n'
          '    print(f"¡Hola, {nombre}!")\n'
          '\n'
          'saludar("Ana")   # imprime: ¡Hola, Ana!\n'
          '\n'
          'Retornar valores con return:\n'
          'def sumar(a, b):\n'
          '    return a + b\n'
          '\n'
          'resultado = sumar(3, 5)   # resultado = 8\n'
          '\n'
          'Parámetros con valor por defecto:\n'
          'def potencia(base, exponente=2):\n'
          '    return base ** exponente\n'
          '\n'
          'potencia(4)     # → 16  (usa exponente=2)\n'
          'potencia(2, 3)  # → 8\n'
          '\n'
          'Funciones lambda (en una sola línea):\n'
          'doble = lambda x: x * 2\n'
          'doble(5)   # → 10\n'
          '\n'
          'Buenas prácticas:\n'
          'Una función debe hacer UNA sola cosa\n'
          'Usa nombres descriptivos: calcular_promedio()\n'
          'Agrega docstrings para documentar',
      trivia: const PreguntaNodo(
        enunciado: '¿Cómo se inicia la definición de una función?',
        opciones: ['a) function mi_func():', 'b) def mi_func():', 'c) void mi_func():'],
        respuestaCorrecta: 1,
      ),
    ),

    // ── NODO 6: Diccionarios ──────────────────────────────────────────────
    NodoAprendizaje(
      numero: 6,
      titulo: 'Diccionarios',
      icono: Icons.book_outlined,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Un diccionario almacena datos en pares clave:valor. Es como una agenda donde cada nombre tiene un número.\n'
          '\n'
          'Crear un diccionario:\n'
          'persona = {\n'
          '    "nombre": "Ana",\n'
          '    "edad": 25,\n'
          '    "activo": True\n'
          '}\n'
          '\n'
          'Acceder a valores:\n'
          'persona["nombre"]       → "Ana"\n'
          'persona.get("edad")     → 25\n'
          'persona.get("email", "N/A")  → "N/A" (valor por defecto)\n'
          '\n'
          'Agregar o modificar:\n'
          'persona["email"] = "ana@mail.com"   # agrega nueva clave\n'
          'persona["edad"]  = 26               # modifica valor\n'
          '\n'
          'Eliminar:\n'
          'del persona["activo"]   # elimina la clave\n'
          'persona.pop("email")    # elimina y retorna el valor\n'
          '\n'
          'Métodos útiles:\n'
          '.keys()   → devuelve todas las claves\n'
          '.values() → devuelve todos los valores\n'
          '.items()  → devuelve pares (clave, valor)\n'
          '\n'
          'Recorrer un diccionario:\n'
          'for clave, valor in persona.items():\n'
          '    print(f"{clave}: {valor}")\n'
          '\n'
          'Diccionarios anidados:\n'
          'usuarios = {\n'
          '    "u1": {"nombre": "Luis", "edad": 30},\n'
          '    "u2": {"nombre": "Mía",  "edad": 22}\n'
          '}',
      trivia: const PreguntaNodo(
        enunciado: '¿Cómo se accede al valor de una clave en un diccionario "d"?',
        opciones: ['a) d["clave"]', 'b) d.get_clave', 'c) d->clave'],
        respuestaCorrecta: 0,
      ),
    ),

    // ── NODO 7: Clases y POO ──────────────────────────────────────────────
    NodoAprendizaje(
      numero: 7,
      titulo: 'Clases y POO',
      icono: Icons.schema_outlined,
      estado: EstadoNodo.bloqueado,
      contenido:
          'La Programación Orientada a Objetos (POO) organiza el código en "objetos" que combinan datos y comportamiento.\n'
          '\n'
          '── Conceptos clave ──\n'
          'Clase    → plantilla o molde para crear objetos\n'
          'Objeto   → instancia concreta de una clase\n'
          'Atributo → variable que pertenece a un objeto\n'
          'Método   → función que pertenece a un objeto\n'
          '\n'
          'Definir una clase:\n'
          'class Perro:\n'
          '    def __init__(self, nombre, raza):\n'
          '        self.nombre = nombre\n'
          '        self.raza   = raza\n'
          '\n'
          '    def ladrar(self):\n'
          '        print(f"{self.nombre} dice: ¡Guau!")\n'
          '\n'
          'Crear objetos:\n'
          'mi_perro = Perro("Rex", "Labrador")\n'
          'mi_perro.ladrar()   # Rex dice: ¡Guau!\n'
          '\n'
          '── Herencia ──\n'
          'Permite que una clase hija herede atributos y métodos de una clase padre.\n'
          'class Animal:\n'
          '    def respirar(self):\n'
          '        print("Respirando...")\n'
          '\n'
          'class Gato(Animal):   # hereda de Animal\n'
          '    def maullar(self):\n'
          '        print("¡Miau!")\n'
          '\n'
          '── Los 4 pilares de la POO ──\n'
          'Encapsulamiento → ocultar detalles internos\n'
          'Herencia        → reutilizar código de otra clase\n'
          'Polimorfismo    → un método, muchos comportamientos\n'
          'Abstracción     → mostrar solo lo necesario',
      trivia: const PreguntaNodo(
        enunciado: '¿Cuál es el nombre del método constructor en una clase de Python?',
        opciones: ['a) constructor()', 'b) __init__()', 'c) main()'],
        respuestaCorrecta: 1,
      ),
    ),

    // ── NODO 8: Manejo de Errores ─────────────────────────────────────────
    NodoAprendizaje(
      numero: 8,
      titulo: 'Manejo de Errores',
      icono: Icons.bug_report_outlined,
      estado: EstadoNodo.bloqueado,
      contenido:
          'Los errores (excepciones) son eventos que interrumpen el flujo normal del programa. Con try/except puedes capturarlos y actuar.\n'
          '\n'
          'Estructura básica:\n'
          'try:\n'
          '    resultado = 10 / 0\n'
          'except ZeroDivisionError:\n'
          '    print("¡No puedes dividir entre cero!")\n'
          '\n'
          'Capturar cualquier error:\n'
          'try:\n'
          '    x = int("hola")\n'
          'except Exception as e:\n'
          '    print(f"Error: {e}")\n'
          '\n'
          'Bloques adicionales:\n'
          'try:\n'
          '    archivo = open("datos.txt")\n'
          'except FileNotFoundError:\n'
          '    print("Archivo no encontrado")\n'
          'else:\n'
          '    print("Archivo abierto con éxito")   # solo si NO hubo error\n'
          'finally:\n'
          '    print("Esto SIEMPRE se ejecuta")     # con o sin error\n'
          '\n'
          'Errores comunes en Python:\n'
          'SyntaxError      → error de escritura en el código\n'
          'NameError        → variable no definida\n'
          'TypeError        → tipo de dato incorrecto\n'
          'IndexError       → índice fuera del rango de una lista\n'
          'KeyError         → clave inexistente en un diccionario\n'
          'ValueError       → valor incorrecto (ej: int("hola"))\n'
          'ZeroDivisionError → división entre cero\n'
          '\n'
          'Lanzar un error manualmente:\n'
          'def validar_edad(edad):\n'
          '    if edad < 0:\n'
          '        raise ValueError("La edad no puede ser negativa")',
      trivia: const PreguntaNodo(
        enunciado: '¿Qué bloque se ejecuta siempre, haya o no un error?',
        opciones: ['a) catch', 'b) finally', 'c) end'],
        respuestaCorrecta: 1,
      ),
    ),
  ];

  void _verificarRespuesta(int indiceNodo, int respuestaUsuario) {
    if (respuestaUsuario == _nodos[indiceNodo].trivia.respuestaCorrecta) {
      setState(() {
        _nodos[indiceNodo].estado = EstadoNodo.completado;
        if (indiceNodo + 1 < _nodos.length) {
          _nodos[indiceNodo + 1].estado = EstadoNodo.actual;
        }
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ ¡Correcto! Nodo desbloqueado.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Incorrecto. Relee e intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _abrirModulo(int indice) {
    if (_nodos[indice].estado == EstadoNodo.bloqueado) return;
    bool mostrarTrivia = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2D0A6B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final nodo = _nodos[indice];
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.92,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, scrollController) => SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicador de arrastre
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Icon(nodo.icono, color: Colors.white, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      mostrarTrivia
                          ? 'Desafío: ${nodo.titulo}'
                          : 'Aprende: ${nodo.titulo}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!mostrarTrivia) ...[
                      // Contenido con fuente monoespaciada para el código
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          nodo.contenido,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.6,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () =>
                              setModalState(() => mostrarTrivia = true),
                          child: const Text(
                            '¡ENTENDIDO, HACER PREGUNTA!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        nodo.trivia.enunciado,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(
                        nodo.trivia.opciones.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _verificarRespuesta(indice, i),
                              child: Text(
                                nodo.trivia.opciones[i],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
            const _BarraSuperior(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      for (int i = 0; i < _nodos.length; i++) ...[
                        if (i > 0)
                          _Conector(
                            completado:
                                _nodos[i - 1].estado == EstadoNodo.completado,
                          ),
                        _BotonNodo(
                          nodo: _nodos[i],
                          onTap: () => _abrirModulo(i),
                        ),
                      ],
                    ],
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

// --- COMPONENTES VISUALES ---

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(top: 50, bottom: 15, left: 20, right: 20),
      decoration:
          BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),
      child: Row(
        children: [
          const Text(
            'RUTA PYTHON',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _Conector extends StatelessWidget {
  final bool completado;
  const _Conector({required this.completado});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: completado
            ? const Color(0xFFF59E0B)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _BotonNodo extends StatelessWidget {
  final NodoAprendizaje nodo;
  final VoidCallback onTap;
  const _BotonNodo({required this.nodo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final esBloqueado = nodo.estado == EstadoNodo.bloqueado;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: esBloqueado ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 210,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _getColor(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getBorder(), width: 3),
            boxShadow: !esBloqueado
                ? [
                    BoxShadow(
                      color: _getColor().withValues(alpha: 0.4),
                      blurRadius: 15,
                    )
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                esBloqueado ? Icons.lock_outline : nodo.icono,
                color: Colors.white,
                size: 35,
              ),
              const SizedBox(height: 10),
              Text(
                nodo.titulo,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    if (nodo.estado == EstadoNodo.completado) return const Color(0xFF16A34A);
    if (nodo.estado == EstadoNodo.actual) return const Color(0xFF2563EB);
    return const Color(0xFF374151);
  }

  Color _getBorder() {
    if (nodo.estado == EstadoNodo.completado) return const Color(0xFFF59E0B);
    if (nodo.estado == EstadoNodo.actual) return const Color(0xFF60A5FA);
    return Colors.white.withValues(alpha: 0.1);
  }
}