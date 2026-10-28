// Генерація скріншотів для PR:
//   flutter test screenshot_test --update-goldens
// Результат: screenshot_test/goldens/*.png
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';

import 'harness.dart';

Widget _app(String route) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: AppTheme.light,
  initialRoute: route,
  routes: AppRoutes.table,
);

void main() {
  setUpAll(loadRealFonts);

  const screens = {
    'login': AppRoutes.login,
    'register': AppRoutes.register,
    'dashboard': AppRoutes.dashboard,
    'profile': AppRoutes.profile,
  };
  for (final e in screens.entries) {
    testWidgets(
      '${e.key} phone',
      (t) => shoot(t, _app(e.value), '${e.key}_phone'),
    );
    testWidgets(
      '${e.key} tablet',
      (t) => shoot(t, _app(e.value), '${e.key}_tablet', size: tablet),
    );
  }
}
