import 'package:flutter/material.dart';

import 'screens/bienvenida.dart';
import 'state.dart';
import 'theme.dart';

void main() {
  runApp(LonchIAApp(state: AppState()));
}

/// Hace que el estado esté disponible en todas las pantallas.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

class LonchIAApp extends StatelessWidget {
  const LonchIAApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'LonchIA',
        debugShowCheckedModeBanner: false,
        theme: lonchiaTheme(),
        home: const BienvenidaScreen(),
      ),
    );
  }
}
