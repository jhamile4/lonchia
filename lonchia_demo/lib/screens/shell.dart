import 'package:flutter/material.dart';

import 'despensa.dart';
import 'impacto.dart';
import 'inicio.dart';
import 'recetas.dart';
import 'semana.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  void irA(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      InicioScreen(irA: irA),
      const DespensaScreen(),
      const RecetasScreen(),
      const SemanaScreen(),
      const ImpactoScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _tab, children: pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: irA,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.kitchen_outlined), selectedIcon: Icon(Icons.kitchen), label: 'Despensa'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Recetas IA'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Semana'),
          NavigationDestination(icon: Icon(Icons.eco_outlined), selectedIcon: Icon(Icons.eco), label: 'Impacto'),
        ],
      ),
    );
  }
}
