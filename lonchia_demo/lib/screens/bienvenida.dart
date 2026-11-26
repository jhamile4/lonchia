import 'package:flutter/material.dart';

import '../theme.dart';
import 'shell.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [LC.verde, Color(0xFF1F6B44)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: LC.doradoClaro,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🍱', style: TextStyle(fontSize: 52)),
                ),
                const SizedBox(height: 28),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white),
                    children: [
                      TextSpan(text: 'Lonch'),
                      TextSpan(text: 'IA', style: TextStyle(color: Color(0xFFF3C969))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tu asistente para loncheras ricas,\nsin que nada se desperdicie.',
                  style: TextStyle(fontSize: 18, color: Colors.white, height: 1.35),
                ),
                const SizedBox(height: 28),
                const _Punto(icono: Icons.receipt_long, texto: 'Registra lo que compras con tu boleta'),
                const _Punto(icono: Icons.notifications_active, texto: 'Te avisamos antes de que algo venza'),
                const _Punto(icono: Icons.auto_awesome, texto: 'Ideas de recetas con lo que ya tienes'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: LC.dorado,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const Shell()),
                    ),
                    child: const Text('Empezar'),
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'Proyecto ODS 12 · Consumo responsable · TECSUP 2026',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Punto extends StatelessWidget {
  const _Punto({required this.icono, required this.texto});
  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFFF3C969)),
          const SizedBox(width: 12),
          Expanded(child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 15))),
        ],
      ),
    );
  }
}
