import 'package:flutter/material.dart';

enum Categoria { frutas, verduras, lacteos, carnes, cereales, enlatados }

extension CategoriaInfo on Categoria {
  String get nombre => const {
        Categoria.frutas: 'Frutas',
        Categoria.verduras: 'Verduras',
        Categoria.lacteos: 'Lácteos',
        Categoria.carnes: 'Carnes y huevos',
        Categoria.cereales: 'Panes y cereales',
        Categoria.enlatados: 'Enlatados',
      }[this]!;

  String get emoji => const {
        Categoria.frutas: '🍎',
        Categoria.verduras: '🥕',
        Categoria.lacteos: '🥛',
        Categoria.carnes: '🍗',
        Categoria.cereales: '🍞',
        Categoria.enlatados: '🥫',
      }[this]!;
}

enum Origen { manual, codigoBarras, boleta }

class Alimento {
  Alimento({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.categoria,
    required this.cantidad,
    required this.unidad,
    required this.vence,
    required this.precio,
    this.origen = Origen.manual,
  });

  final String id;
  final String nombre;
  final String emoji;
  final Categoria categoria;
  int cantidad;
  final String unidad;
  final DateTime vence;
  final double precio;
  final Origen origen;

  int get diasRestantes {
    final hoy = DateUtils.dateOnly(DateTime.now());
    return DateUtils.dateOnly(vence).difference(hoy).inDays;
  }

  Prioridad get prioridad {
    final d = diasRestantes;
    if (d < 0) return Prioridad.vencido;
    if (d <= 1) return Prioridad.urgente;
    if (d <= 3) return Prioridad.pronto;
    if (d <= 5) return Prioridad.atento;
    return Prioridad.tranquilo;
  }

  String get textoVence {
    final d = diasRestantes;
    if (d < 0) return 'Venció hace ${-d} d';
    if (d == 0) return 'Vence hoy';
    if (d == 1) return 'Vence mañana';
    return 'Vence en $d días';
  }
}

enum Prioridad { vencido, urgente, pronto, atento, tranquilo }

extension PrioridadInfo on Prioridad {
  Color get color => const {
        Prioridad.vencido: Color(0xFF8E8E8E),
        Prioridad.urgente: Color(0xFFE5484D),
        Prioridad.pronto: Color(0xFFF08A24),
        Prioridad.atento: Color(0xFFE8B931),
        Prioridad.tranquilo: Color(0xFF3FA66B),
      }[this]!;

  String get etiqueta => const {
        Prioridad.vencido: 'Vencido',
        Prioridad.urgente: 'Úsalo ya',
        Prioridad.pronto: 'Pronto',
        Prioridad.atento: 'Atento',
        Prioridad.tranquilo: 'Tranquilo',
      }[this]!;
}

class Receta {
  const Receta({
    required this.nombre,
    required this.emoji,
    required this.tipo,
    required this.minutos,
    required this.ingredientes,
    required this.pasos,
    required this.claves,
  });

  final String nombre;
  final String emoji;
  final String tipo; // Lonchera o Almuerzo
  final int minutos;
  final List<String> ingredientes;
  final List<String> pasos;

  /// Palabras que se buscan en el inventario para saber si la receta aprovecha algo.
  final List<String> claves;
}

class RecetaSugerida {
  RecetaSugerida(this.receta, this.usaDeCasa, this.puntaje);
  final Receta receta;
  final List<Alimento> usaDeCasa;
  final double puntaje;

  Alimento? get prioridad {
    if (usaDeCasa.isEmpty) return null;
    final copia = [...usaDeCasa]..sort((a, b) => a.diasRestantes.compareTo(b.diasRestantes));
    return copia.first;
  }
}
