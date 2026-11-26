import 'package:flutter/material.dart';

import 'main.dart';
import 'models.dart';
import 'theme.dart';

class ChipPrioridad extends StatelessWidget {
  const ChipPrioridad(this.alimento, {super.key});
  final Alimento alimento;

  @override
  Widget build(BuildContext context) {
    final c = alimento.prioridad.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        alimento.textoVence,
        style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class EmojiBox extends StatelessWidget {
  const EmojiBox(this.emoji, {super.key, this.size = 48, this.color = LC.doradoClaro});
  final String emoji;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * 0.3)),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

class AlimentoTile extends StatelessWidget {
  const AlimentoTile(this.a, {super.key});
  final Alimento a;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        child: Row(
          children: [
            EmojiBox(a.emoji),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(a.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                      if (a.origen != Origen.manual) ...[
                        const SizedBox(width: 6),
                        Icon(a.origen == Origen.boleta ? Icons.receipt_long : Icons.qr_code_scanner,
                            size: 14, color: LC.dorado),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${a.cantidad} ${a.unidad}', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(width: 8),
                      ChipPrioridad(a),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (v) {
                if (v == 'usar') {
                  state.usar(a);
                  _aviso(context, '¡Bien! ${a.nombre} aprovechado ✅');
                } else {
                  state.perder(a);
                  _aviso(context, '${a.nombre} se agregó a tu lista de compras');
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'usar', child: Text('✅  Lo usé')),
                PopupMenuItem(value: 'perder', child: Text('🗑️  Se perdió')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _aviso(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
}

void aviso(BuildContext context, String msg) => _aviso(context, msg);

class Titulo extends StatelessWidget {
  const Titulo(this.texto, {super.key, this.accion});
  final String texto;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(texto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          if (accion != null) accion!,
        ],
      ),
    );
  }
}
