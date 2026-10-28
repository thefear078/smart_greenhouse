import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/data/services/mqtt_sensor_service.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  test('MQTT payload parsing', () {
    expect(MqttSensorService.parsePayload('24.5'), 24.5);
    expect(MqttSensorService.parsePayload('{"value": 41}'), 41);
    expect(MqttSensorService.parsePayload('hello'), isNull);
    expect(SensorKind.fromTopic('a/b/greenhouse/soil'), SensorKind.soil);
  });

  testWidgets('auto-login skips login screen', (tester) async {
    await tester.pumpWidget(await buildApp(userPrefs(session: true)));
    await tester.pumpAndSettle();
    expect(find.text('Датчики'), findsOneWidget);
  });

  testWidgets('offline auto-login shows warning dialog and banner', (
    tester,
  ) async {
    final net = FakeNetwork(online: false);
    await tester.pumpWidget(await buildApp(userPrefs(session: true), net));
    await tester.pumpAndSettle();
    expect(find.text('Немає підключення'), findsOneWidget);
    await tapOn(tester, find.text('Зрозуміло'));
    expect(find.byKey(const Key('offlineBanner')), findsOneWidget);
  });

  testWidgets('login is blocked without internet', (tester) async {
    final net = FakeNetwork(online: false);
    await tester.pumpWidget(await buildApp(userPrefs(), net));
    await typeInto(tester, 'Email', 'k@lpnu.ua');
    await typeInto(tester, 'Пароль', 'secret123');
    await tapOn(tester, find.text('Увійти'));
    expect(find.text('Немає інтернету — вхід неможливий'), findsOneWidget);
    expect(find.text('Вхід'), findsOneWidget);
  });

  testWidgets('real-time network loss, MQTT data, logout dialog', (
    tester,
  ) async {
    final net = FakeNetwork();
    final sensors = FakeSensors();
    await tester.pumpWidget(
      await buildApp(userPrefs(session: true), net, sensors),
    );
    await tester.pumpAndSettle();
    expect(sensors.connects, 1);

    sensors.emit(SensorKind.temperature, 27.3);
    sensors.emit(SensorKind.soil, 30);
    await tester.pumpAndSettle();
    expect(find.textContaining('27.3'), findsOneWidget);
    expect(find.text('Потрібен полив'), findsOneWidget);

    net.set(false);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('offlineBanner')), findsOneWidget);
    net.set(true);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('offlineBanner')), findsNothing);

    await tapOn(tester, find.byTooltip('Профіль'));
    await tapOn(tester, find.text('Вийти'));
    expect(find.text('Вийти з акаунта?'), findsOneWidget);
    await tapOn(tester, find.text('Скасувати'));
    expect(find.text('Обліковий запис'), findsOneWidget);
    await tapOn(tester, find.text('Вийти'));
    await tapOn(tester, find.widgetWithText(FilledButton, 'Вийти'));
    expect(find.text('Вхід'), findsOneWidget);
    expect(sensors.disconnects, greaterThanOrEqualTo(1));
  });
}
