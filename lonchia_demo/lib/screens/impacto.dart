import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';
import '../widgets.dart';

class ImpactoScreen extends StatelessWidget {
  const ImpactoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final total = s.aprovechados + s.desperdiciados;
    final tasa = total == 0 ? 0.0 : s.aprovechados / total;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi impacto')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: LC.dorado, borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              SizedBox(
                width: 92,
                height: 92,
                child: Stack(fit: StackFit.expand, children: [
                  CircularProgressIndicator(
                    value: tasa,
                    strokeWidth: 10,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                  Center(
                    child: Text('${(tasa * 100).round()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ),
                ]),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Text('de tus alimentos se aprovecharon en vez de ir a la basura',
                    style: TextStyle(color: Colors.white, fontSize: 16, height: 1.35, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            _Dato('✅', '${s.aprovechados}', 'Aprovechados'),
            const SizedBox(width: 10),
            _Dato('🛟', '${s.salvados}', 'Salvados a tiempo'),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _Dato('💰', 'S/ ${s.solesAhorrados.toStringAsFixed(2)}', 'Ahorrados'),
            const SizedBox(width: 10),
            _Dato('🗑️', '${s.desperdiciados}', 'Desperdiciados'),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: LC.verdeClaro, borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [
              Text('🌎', style: TextStyle(fontSize: 26)),
              SizedBox(width: 10),
              Expanded(
                child: Text('Aportas a la Meta 12.3 de los ODS: reducir a la mitad el desperdicio de alimentos.',
                    style: TextStyle(height: 1.35)),
              ),
            ]),
          ),
          Titulo('Lista de compras inteligente',
              accion: Text('${s.listaCompras.length} items', style: const TextStyle(color: Colors.black54))),
          Card(
            child: Column(
              children: [
                if (s.listaCompras.isEmpty)
                  const Padding(padding: EdgeInsets.all(16), child: Text('Tu lista está vacía')),
                for (final item in [...s.listaCompras])
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {
                      s.alternarCompra(item);
                      aviso(context, '$item comprado');
                    },
                    title: Text(item),
                    subtitle: const Text('Se acabó o se perdió'),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Solo agregamos lo que falta, para no comprar repetido.',
                style: TextStyle(color: Colors.black54, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato(this.emoji, this.valor, this.texto);
  final String emoji, valor, texto;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: LC.verde)),
            Text(texto, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}
