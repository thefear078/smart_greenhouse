import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/data/services/plugin_flashlight.dart';
import 'package:smart_greenhouse/domain/services/flashlight_service.dart';

import 'fakes.dart';
import 'helpers.dart';

void main() {
  testWidgets('Easter egg: long press on logo toggles flashlight', (
    tester,
  ) async {
    final torch = FakeFlashlight();
    await tester.pumpWidget(
      await buildApp(userPrefs(session: true), null, null, torch),
    );
    await tester.pumpAndSettle();
    await tester.longPress(find.byKey(const Key('greenhouseLogo')));
    await tester.pumpAndSettle();
    expect(torch.isOn, isTrue);
    expect(find.text('🔦 Ліхтарик увімкнено'), findsOneWidget);
  });

  testWidgets('no flash: friendly message instead of crash', (tester) async {
    final torch = FakeFlashlight(failure: 'На пристрої немає спалаху');
    await tester.pumpWidget(
      await buildApp(userPrefs(session: true), null, null, torch),
    );
    await tester.pumpAndSettle();
    await tester.longPress(find.byKey(const Key('greenhouseLogo')));
    await tester.pumpAndSettle();
    expect(find.text('На пристрої немає спалаху'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('plugin on iOS -> FlashlightFailure (graceful degradation)', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await expectLater(
      PluginFlashlight().toggle(),
      throwsA(
        isA<FlashlightFailure>().having((e) => e.message, 'm', contains('iOS')),
      ),
    );
  });
}
