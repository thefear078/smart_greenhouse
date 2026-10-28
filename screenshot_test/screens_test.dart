// Генерація скріншотів для PR:
//   flutter test screenshot_test --update-goldens
// Результат: screenshot_test/goldens/*.png
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';

import '../test/fakes.dart';
import '../test/helpers.dart';
import 'harness.dart';

FakeSensors _sensors() => FakeSensors();

Future<void> _feed(FakeSensors s) async {
  s
    ..emit(SensorKind.temperature, 24.5)
    ..emit(SensorKind.humidity, 68)
    ..emit(SensorKind.soil, 41)
    ..emit(SensorKind.light, 12400);
}

void main() {
  setUpAll(loadRealFonts);

  for (final size in [phone, tablet]) {
    final tag = size == phone ? 'phone' : 'tablet';
    testWidgets('login $tag', (t) async {
      await shoot(t, await buildApp(), 'login_$tag', size: size);
    });
    testWidgets('dashboard $tag', (t) async {
      final s = _sensors();
      final app = await buildApp(userPrefs(session: true), null, s);
      await shoot(
        t,
        app,
        'dashboard_$tag',
        size: size,
        before: (_) => _feed(s),
      );
    });
    testWidgets('dashboard offline $tag', (t) async {
      final net = FakeNetwork();
      final s = _sensors();
      final app = await buildApp(userPrefs(session: true), net, s);
      await shoot(
        t,
        app,
        'dashboard_offline_$tag',
        size: size,
        before: (_) async {
          await _feed(s);
          net.set(false);
        },
      );
    });
    testWidgets('profile $tag', (t) async {
      final app = await buildApp(userPrefs(session: true));
      await shoot(
        t,
        app,
        'profile_$tag',
        size: size,
        before: (t) => tapOn(t, find.byTooltip('Профіль')),
      );
    });
  }
}
