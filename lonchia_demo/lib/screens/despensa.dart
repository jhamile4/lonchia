import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'agregar.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});
  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  Categoria? _filtro;

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final lista = s.despensa.where((a) => _filtro == null || a.categoria == _filtro).toList()
      ..sort((a, b) => a.diasRestantes.compareTo(b.diasRestantes));

    return Scaffold(
      appBar: AppBar(title: const Text('Mi despensa')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: LC.dorado,
        foregroundColor: Colors.white,
        onPressed: () => mostrarOpcionesAgregar(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Todo (${s.despensa.length})'),
                    selected: _filtro == null,
                    onSelected: (_) => setState(() => _filtro = null),
                  ),
                ),
                for (final c in Categoria.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${c.emoji} ${c.nombre}'),
                      selected: _filtro == c,
                      onSelected: (_) => setState(() => _filtro = c),
                    ),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.black45),
                SizedBox(width: 6),
                Expanded(
                  child: Text('Ordenado por lo que vence primero. Toca ⋮ para marcar si lo usaste.',
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('No hay alimentos en esta categoría'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: lista.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => AlimentoTile(lista[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
