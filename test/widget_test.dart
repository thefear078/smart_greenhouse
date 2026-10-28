import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/counter/counter_command.dart';
import 'package:smart_greenhouse/main.dart';

Future<void> _enter(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const Key('counterInput')), text);
  await tester.tap(find.byKey(const Key('submitButton')));
  await tester.pumpAndSettle();
}

void main() {
  group('CounterCommand.parse', () {
    test('integer -> AddCommand', () {
      expect((CounterCommand.parse('5') as AddCommand).value, 5);
      expect((CounterCommand.parse(' -12 ') as AddCommand).value, -12);
    });
    test('exact phrase -> ResetCommand', () {
      expect(CounterCommand.parse('Avada Kedavra'), isA<ResetCommand>());
    });
    test('anything else -> InvalidCommand', () {
      for (final s in ['', 'abc', '1.5', '2,5', 'avada kedavra', '@#']) {
        expect(CounterCommand.parse(s), isA<InvalidCommand>(), reason: s);
      }
    });
  });

  testWidgets('add, reset and invalid input scenarios', (tester) async {
    await tester.pumpWidget(const SmartGreenhouseApp());
    expect(find.text('0'), findsOneWidget);

    await _enter(tester, '7');
    await _enter(tester, '-2');
    expect(find.text('5'), findsOneWidget);

    await _enter(tester, '3.14');
    expect(find.text('5'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);

    await _enter(tester, 'Avada Kedavra');
    expect(find.text('0'), findsOneWidget);
  });
}
