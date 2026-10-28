import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/di/injector.dart';
import 'package:smart_greenhouse/main.dart';
import 'package:smart_greenhouse/ui/routes.dart';

import 'fakes.dart';

/// Збережений користувач k@lpnu.ua / secret123.
Map<String, Object> userPrefs({bool session = false}) => {
  'users':
      '[{"name":"Костянтин Ягусевич","email":"k@lpnu.ua",'
      '"passwordHash":"${LocalAuthRepository.hash('secret123')}"}]',
  if (session) 'session_email': 'k@lpnu.ua',
};

/// Збирає застосунок поверх in-memory SharedPreferences і фейків,
/// реєструючи їх у DI-контейнері (як configureDependencies у main).
Future<Widget> buildApp([
  Map<String, Object> prefs = const {},
  FakeNetwork? network,
  FakeSensors? sensors,
  FakeFlashlight? flashlight,
]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final store = await JsonStore.create();
  await registerDependencies(
    auth: LocalAuthRepository(store),
    devices: LocalDeviceRepository(store),
    network: network ?? FakeNetwork(),
    sensors: sensors ?? FakeSensors(),
    flashlight: flashlight ?? FakeFlashlight(),
  );
  return SmartGreenhouseApp(
    initialRoute: hasSession ? AppRoutes.dashboard : AppRoutes.login,
  );
}

Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> typeInto(WidgetTester tester, String label, String text) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
}
