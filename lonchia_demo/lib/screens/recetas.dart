import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});
  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  bool _pensando = false;
  List<RecetaSugerida>? _ideas;
  String _tipo = 'Todas';

  Future<void> _generar() async {
    setState(() => _pensando = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() {
      _ideas = AppScope.of(context).sugerirRecetas();
      _pensando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ideas = _ideas?.where((r) => _tipo == 'Todas' || r.receta.tipo == _tipo).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas con IA')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [LC.verde, Color(0xFF3FAE73)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFF3C969)),
                  SizedBox(width: 8),
                  Text('Asistente LonchIA',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'Reviso tu despensa y te propongo loncheras y almuerzos rápidos, '
                  'empezando por lo que vence primero.',
                  style: TextStyle(color: Colors.white, height: 1.35),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: LC.verde),
                  onPressed: _pensando ? null : _generar,
                  icon: _pensando
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.restaurant_menu),
                  label: Text(_pensando
                      ? 'Pensando ideas...'
                      : (_ideas == null ? 'Generar ideas' : 'Generar otra vez')),
                ),
              ],
            ),
          ),
          if (ideas != null) ...[
            const SizedBox(height: 14),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Todas', label: Text('Todas')),
                ButtonSegment(value: 'Lonchera', label: Text('Lonchera')),
                ButtonSegment(value: 'Almuerzo', label: Text('Almuerzo')),
              ],
              selected: {_tipo},
              onSelectionChanged: (v) => setState(() => _tipo = v.first),
            ),
            const SizedBox(height: 8),
            for (final r in ideas) _TarjetaReceta(r),
            if (ideas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Agrega más alimentos para recibir ideas.')),
              ),
          ] else if (!_pensando)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(children: [
                Text('👩‍🍳', style: TextStyle(fontSize: 64)),
                SizedBox(height: 8),
                Text('Toca "Generar ideas" para empezar', style: TextStyle(color: Colors.black54)),
              ]),
            ),
        ],
      ),
    );
  }
}

class _TarjetaReceta extends StatelessWidget {
  const _TarjetaReceta(this.s);
  final RecetaSugerida s;

  @override
  Widget build(BuildContext context) {
    final p = s.prioridad;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleReceta(s))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                EmojiBox(s.receta.emoji, size: 64),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.receta.nombre, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${s.receta.tipo} · ${s.receta.minutos} min · usa ${s.usaDeCasa.length} de tu casa',
                          style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      if (p != null && p.diasRestantes <= 3) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: p.prioridad.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Aprovecha: ${p.nombre} (${p.textoVence.toLowerCase()})',
                              style: TextStyle(color: p.prioridad.color, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetalleReceta extends StatelessWidget {
  const DetalleReceta(this.s, {super.key});
  final RecetaSugerida s;

  @override
  Widget build(BuildContext context) {
    final r = s.receta;
    return Scaffold(
      appBar: AppBar(title: Text(r.tipo)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: EmojiBox(r.emoji, size: 110)),
          const SizedBox(height: 16),
          Text(r.nombre, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('⏱ ${r.minutos} minutos · fácil de empacar', textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54)),
          const Titulo('Ingredientes'),
          for (final i in r.ingredientes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                const Icon(Icons.circle, size: 8, color: LC.dorado),
                const SizedBox(width: 10),
                Expanded(child: Text(i)),
              ]),
            ),
          const Titulo('De tu despensa'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final a in s.usaDeCasa) Chip(label: Text('${a.emoji} ${a.nombre}'))],
          ),
          const Titulo('Preparación'),
          for (final (n, paso) in r.pasos.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(radius: 13, backgroundColor: LC.verde,
                    child: Text('${n + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                const SizedBox(width: 10),
                Expanded(child: Text(paso, style: const TextStyle(height: 1.4))),
              ]),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              final st = AppScope.of(context);
              final n = s.usaDeCasa.length;
              for (final a in [...s.usaDeCasa]) {
                if (st.despensa.contains(a)) st.usar(a);
              }
              aviso(context, '¡Lonchera lista! Aprovechaste $n alimentos 🌱');
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Ya la preparé'),
          ),
        ],
      ),
    );
  }
}
