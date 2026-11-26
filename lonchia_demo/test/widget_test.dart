import 'package:flutter_test/flutter_test.dart';
import 'package:lonchia/main.dart';
import 'package:lonchia/state.dart';

void main() {
  testWidgets('Muestra la bienvenida y entra al inicio', (tester) async {
    await tester.pumpWidget(LonchIAApp(state: AppState()));
    expect(find.text('Empezar'), findsOneWidget);
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué va en la lonchera hoy?'), findsOneWidget);
  });

  test('La IA de la demo prioriza lo que vence primero', () {
    final ideas = AppState().sugerirRecetas();
    expect(ideas, isNotEmpty);
    // La primera idea debe usar algo que vence en 1 día o menos (yogurt o plátano).
    expect(ideas.first.prioridad!.diasRestantes, lessThanOrEqualTo(1));
  });
}
