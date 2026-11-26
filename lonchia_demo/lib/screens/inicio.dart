import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'agregar.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key, required this.irA});
  final void Function(int) irA;

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final urgentes = s.porVencer;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡Hola, familia! 👋', style: TextStyle(fontSize: 15, color: Colors.black54)),
                    SizedBox(height: 2),
                    Text('¿Qué va en la lonchera hoy?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _mostrarNotificacion(context, urgentes.isEmpty ? null : urgentes.first.nombre),
                icon: Badge(
                  isLabelVisible: urgentes.isNotEmpty,
                  label: Text('${urgentes.length}'),
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Tarjeta de alerta principal
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [LC.dorado, Color(0xFFD9A441)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${urgentes.length} alimentos por vencer',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('Úsalos primero y evita botarlos.',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: LC.dorado,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        onPressed: () => irA(2),
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('Ver recetas con IA'),
                      ),
                    ],
                  ),
                ),
                const Text('⏰', style: TextStyle(fontSize: 54)),
              ],
            ),
          ),

          Titulo('Úsalos primero', accion: TextButton(onPressed: () => irA(1), child: const Text('Ver despensa'))),
          SizedBox(
            height: 150,
            child: urgentes.isEmpty
                ? const Card(child: Center(child: Text('Nada urgente. ¡Todo bajo control! 🎉')))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: urgentes.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final a = urgentes[i];
                      return Container(
                        width: 120,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: a.prioridad.color.withValues(alpha: 0.5), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.emoji, style: const TextStyle(fontSize: 30)),
                            const Spacer(),
                            Text(a.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(a.textoVence,
                                style: TextStyle(color: a.prioridad.color, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const Titulo('Agregar alimentos'),
          Row(
            children: [
              _Accion(icono: Icons.receipt_long, texto: 'Boleta\n(OCR)', color: LC.verde,
                  onTap: () => abrirAgregar(context, 2)),
              const SizedBox(width: 10),
              _Accion(icono: Icons.qr_code_scanner, texto: 'Código de\nbarras', color: LC.dorado,
                  onTap: () => abrirAgregar(context, 1)),
              const SizedBox(width: 10),
              _Accion(icono: Icons.edit_note, texto: 'Ingreso\nmanual', color: LC.coral,
                  onTap: () => abrirAgregar(context, 0)),
            ],
          ),

          const Titulo('Tu impacto esta semana'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Mini('${s.aprovechados}', 'aprovechados'),
                  _Mini('${s.salvados}', 'salvados'),
                  _Mini('S/ ${s.solesAhorrados.toStringAsFixed(2)}', 'ahorrados'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarNotificacion(BuildContext context, String? nombre) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'notificación',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
              ),
              child: Row(
                children: [
                  const EmojiBox('🍱', size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('LonchIA · ahora', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text(
                          nombre == null
                              ? 'No tienes alimentos por vencer 🎉'
                              : '¡$nombre está por vencer! Mira 3 ideas de lonchera para usarlo hoy.',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, _, child) => SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  const _Accion({required this.icono, required this.texto, required this.color, required this.onTap});
  final IconData icono;
  final String texto;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icono, color: color, size: 30),
                const SizedBox(height: 6),
                Text(texto,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini(this.valor, this.texto);
  final String valor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: LC.verde)),
        Text(texto, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}
