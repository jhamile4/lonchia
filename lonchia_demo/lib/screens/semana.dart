import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';

class SemanaScreen extends StatelessWidget {
  const SemanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mi semana')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const Text('Planifica loncheras y almuerzos. Así compras solo lo necesario.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          for (final dia in s.semana.keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dia, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: _Slot(dia: dia, momento: 'Lonchera')),
                        const SizedBox(width: 8),
                        Expanded(child: _Slot(dia: dia, momento: 'Almuerzo')),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.dia, required this.momento});
  final String dia;
  final String momento;

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final r = s.semana[dia]![momento];
    final color = momento == 'Lonchera' ? LC.dorado : LC.verde;
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _elegir(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Text(r?.emoji ?? '＋', style: TextStyle(fontSize: 22, color: color)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(momento, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
                Text(r?.nombre ?? 'Elegir', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  void _elegir(BuildContext context) {
    final s = AppScope.of(context);
    final opciones = catalogoRecetas.where((r) => r.tipo == momento).toList();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text('$momento del $dia', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            for (final Receta r in opciones)
              ListTile(
                leading: Text(r.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(r.nombre),
                subtitle: Text('${r.minutos} min'),
                onTap: () {
                  s.planificar(dia, momento, r);
                  Navigator.pop(ctx);
                },
              ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Dejar vacío'),
              onTap: () {
                s.planificar(dia, momento, null);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
