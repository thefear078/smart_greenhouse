import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/main.dart';

Future<void> _setSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('navigation: login -> register -> back -> dashboard -> profile', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartGreenhouseApp());
    expect(find.text('Вхід'), findsOneWidget);

    await _tap(tester, find.text('Немає акаунта? Зареєструватися'));
    expect(find.text('Реєстрація'), findsOneWidget);

    await _tap(tester, find.text('Вже є акаунт? Увійти'));
    await _tap(tester, find.text('Увійти'));
    expect(find.text('Датчики'), findsOneWidget);

    await _tap(tester, find.byTooltip('Профіль'));
    expect(find.text('Обліковий запис'), findsOneWidget);
  });

  for (final size in const [Size(375, 667), Size(1024, 1366)]) {
    testWidgets('no overflow on ${size.width.toInt()}dp', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(const SmartGreenhouseApp());
      await _tap(tester, find.text('Увійти'));
      expect(tester.takeException(), isNull);
      await _tap(tester, find.byTooltip('Профіль'));
      expect(tester.takeException(), isNull);
    });
  }
}
