import 'dart:math';

import 'package:flutter/material.dart';

import 'models.dart';

/// Estado de la demo. Todo vive en memoria: no hay backend real,
/// los servicios de OCR, código de barras e IA se simulan.
class AppState extends ChangeNotifier {
  AppState() {
    _cargarDatosDeEjemplo();
  }

  final List<Alimento> despensa = [];
  int _contador = 0;

  // Panel de impacto
  int aprovechados = 0;
  int salvados = 0; // usados cuando faltaban 3 días o menos
  int desperdiciados = 0;
  double solesAhorrados = 0;

  // Planificador: día -> {"Lonchera": receta, "Almuerzo": receta}
  final Map<String, Map<String, Receta?>> semana = {
    for (final d in const ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'])
      d: {'Lonchera': null, 'Almuerzo': null},
  };

  final List<String> listaCompras = ['Pan integral', 'Plátanos'];

  DateTime _en(int dias) => DateUtils.dateOnly(DateTime.now()).add(Duration(days: dias));

  void _cargarDatosDeEjemplo() {
    void add(String n, String e, Categoria c, int cant, String u, int dias, double p) =>
        despensa.add(Alimento(
            id: '${_contador++}', nombre: n, emoji: e, categoria: c,
            cantidad: cant, unidad: u, vence: _en(dias), precio: p));

    add('Plátano de seda', '🍌', Categoria.frutas, 4, 'und', 1, 2.0);
    add('Palta', '🥑', Categoria.frutas, 2, 'und', 2, 4.5);
    add('Manzana', '🍎', Categoria.frutas, 5, 'und', 9, 3.5);
    add('Yogurt de fresa', '🥛', Categoria.lacteos, 1, 'L', 0, 7.9);
    add('Queso fresco', '🧀', Categoria.lacteos, 1, 'trozo', 3, 9.0);
    add('Huevos', '🥚', Categoria.carnes, 6, 'und', 12, 6.0);
    add('Pechuga de pollo', '🍗', Categoria.carnes, 1, 'kg', 2, 14.5);
    add('Zanahoria', '🥕', Categoria.verduras, 3, 'und', 5, 1.5);
    add('Tomate', '🍅', Categoria.verduras, 4, 'und', 4, 2.4);
    add('Pan de molde', '🍞', Categoria.cereales, 1, 'bolsa', 3, 8.5);
    add('Avena', '🥣', Categoria.cereales, 1, 'bolsa', 60, 5.2);
    add('Atún en lata', '🐟', Categoria.enlatados, 2, 'lata', 200, 6.8);
  }

  List<Alimento> get porVencer {
    final l = despensa.where((a) => a.diasRestantes <= 3).toList()
      ..sort((a, b) => a.diasRestantes.compareTo(b.diasRestantes));
    return l;
  }

  void agregar({
    required String nombre,
    required String emoji,
    required Categoria categoria,
    required int cantidad,
    required String unidad,
    required int diasParaVencer,
    required double precio,
    Origen origen = Origen.manual,
  }) {
    despensa.add(Alimento(
      id: '${_contador++}',
      nombre: nombre,
      emoji: emoji,
      categoria: categoria,
      cantidad: cantidad,
      unidad: unidad,
      vence: _en(diasParaVencer),
      precio: precio,
      origen: origen,
    ));
    listaCompras.removeWhere((x) => x.toLowerCase() == nombre.toLowerCase());
    notifyListeners();
  }

  void usar(Alimento a) {
    aprovechados++;
    if (a.diasRestantes <= 3) {
      salvados++;
      solesAhorrados += a.precio;
    }
    despensa.remove(a);
    notifyListeners();
  }

  void perder(Alimento a) {
    desperdiciados++;
    despensa.remove(a);
    if (!listaCompras.contains(a.nombre)) listaCompras.add(a.nombre);
    notifyListeners();
  }

  void alternarCompra(String item) {
    listaCompras.contains(item) ? listaCompras.remove(item) : listaCompras.add(item);
    notifyListeners();
  }

  void planificar(String dia, String momento, Receta? r) {
    semana[dia]![momento] = r;
    notifyListeners();
  }

  /// "IA" de la demo: puntúa cada receta según los ingredientes de casa,
  /// dando mucho más peso a los que vencen primero.
  /// En la versión real esto lo hace OpenAI o Gemini desde el backend.
  List<RecetaSugerida> sugerirRecetas() {
    final res = <RecetaSugerida>[];
    for (final r in catalogoRecetas) {
      final usa = <Alimento>[];
      double puntaje = 0;
      for (final a in despensa) {
        final n = a.nombre.toLowerCase();
        if (r.claves.any((c) => n.contains(c))) {
          usa.add(a);
          final d = max(a.diasRestantes, 0);
          puntaje += 10 / (d + 1) + 1;
        }
      }
      if (usa.isNotEmpty) res.add(RecetaSugerida(r, usa, puntaje));
    }
    res.sort((a, b) => b.puntaje.compareTo(a.puntaje));
    return res;
  }
}

const catalogoRecetas = <Receta>[
  Receta(
    nombre: 'Sánguche de pollo con palta',
    emoji: '🥪',
    tipo: 'Lonchera',
    minutos: 10,
    ingredientes: ['2 tajadas de pan de molde', 'Pollo deshilachado', '1/2 palta', 'Rodajas de tomate'],
    pasos: ['Deshilacha el pollo ya cocido.', 'Aplasta la palta con una pizca de sal.', 'Arma el sánguche y córtalo en triángulos para que entre en el táper.'],
    claves: ['pan', 'pollo', 'palta', 'tomate'],
  ),
  Receta(
    nombre: 'Yogurt con plátano y avena',
    emoji: '🍨',
    tipo: 'Lonchera',
    minutos: 5,
    ingredientes: ['1 vaso de yogurt', '1 plátano en rodajas', '2 cucharadas de avena'],
    pasos: ['Sirve el yogurt en un envase con tapa.', 'Agrega el plátano y la avena encima.', 'Guárdalo frío hasta la hora del recreo.'],
    claves: ['yogurt', 'plátano', 'avena'],
  ),
  Receta(
    nombre: 'Panqueques de plátano',
    emoji: '🥞',
    tipo: 'Lonchera',
    minutos: 15,
    ingredientes: ['2 plátanos maduros', '2 huevos', '4 cucharadas de avena'],
    pasos: ['Aplasta los plátanos con un tenedor.', 'Mezcla con los huevos y la avena.', 'Cocina pequeñas porciones en sartén. Ideales para empacar.'],
    claves: ['plátano', 'huevo', 'avena'],
  ),
  Receta(
    nombre: 'Arroz con pollo y zanahoria',
    emoji: '🍛',
    tipo: 'Almuerzo',
    minutos: 35,
    ingredientes: ['Pechuga de pollo', '1 zanahoria en cubitos', 'Arroz', 'Culantro'],
    pasos: ['Dora el pollo en trozos.', 'Agrega el aderezo y la zanahoria.', 'Suma el arroz y el agua, y cocina tapado 20 minutos.'],
    claves: ['pollo', 'zanahoria'],
  ),
  Receta(
    nombre: 'Tortilla de verduras',
    emoji: '🍳',
    tipo: 'Almuerzo',
    minutos: 15,
    ingredientes: ['3 huevos', 'Zanahoria rallada', 'Tomate picado', 'Queso fresco'],
    pasos: ['Bate los huevos.', 'Agrega las verduras y el queso en cubitos.', 'Cocina a fuego bajo por ambos lados.'],
    claves: ['huevo', 'zanahoria', 'tomate', 'queso'],
  ),
  Receta(
    nombre: 'Brochetas de fruta y queso',
    emoji: '🍢',
    tipo: 'Lonchera',
    minutos: 8,
    ingredientes: ['Manzana en cubos', 'Plátano', 'Queso fresco en cubos'],
    pasos: ['Corta todo en cubos parecidos.', 'Arma palitos alternando fruta y queso.', 'Unas gotas de limón evitan que la manzana se ponga oscura.'],
    claves: ['manzana', 'plátano', 'queso'],
  ),
  Receta(
    nombre: 'Ensalada de atún',
    emoji: '🥗',
    tipo: 'Almuerzo',
    minutos: 10,
    ingredientes: ['1 lata de atún', 'Tomate', 'Palta', 'Zanahoria rallada'],
    pasos: ['Escurre el atún.', 'Pica el tomate y la palta.', 'Mezcla todo y sazona con limón y sal.'],
    claves: ['atún', 'tomate', 'palta', 'zanahoria'],
  ),
  Receta(
    nombre: 'Triples caseros',
    emoji: '🥙',
    tipo: 'Lonchera',
    minutos: 12,
    ingredientes: ['Pan de molde', 'Palta', 'Tomate', 'Huevo duro'],
    pasos: ['Sancocha el huevo y córtalo en rodajas.', 'Arma capas de palta, tomate y huevo.', 'Corta en triángulos y envuelve.'],
    claves: ['pan', 'palta', 'tomate', 'huevo'],
  ),
];
