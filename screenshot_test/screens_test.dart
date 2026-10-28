// Генерація скріншотів для PR:
//   flutter test screenshot_test --update-goldens
// Результат: screenshot_test/goldens/*.png
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';

import '../test/helpers.dart';
import 'harness.dart';

final _users = {
  'users':
      '[{"name":"Костянтин Ягусевич","email":"kostiantyn@lpnu.ua",'
      '"passwordHash":"${LocalAuthRepository.hash('secret123')}"}]',
};

Future<void> _toDashboard(WidgetTester t) async {
  await typeInto(t, 'Email', 'kostiantyn@lpnu.ua');
  await typeInto(t, 'Пароль', 'secret123');
  await tapOn(t, find.text('Увійти'));
}

void main() {
  setUpAll(loadRealFonts);

  for (final size in [phone, tablet]) {
    final tag = size == phone ? 'phone' : 'tablet';
    testWidgets('login $tag', (t) async {
      await shoot(t, await buildApp(), 'login_$tag', size: size);
    });
    testWidgets('dashboard $tag', (t) async {
      final app = await buildApp(_users);
      await shoot(t, app, 'dashboard_$tag', size: size, before: _toDashboard);
    });
    testWidgets('profile $tag', (t) async {
      final app = await buildApp(_users);
      await shoot(
        t,
        app,
        'profile_$tag',
        size: size,
        before: (t) async {
          await _toDashboard(t);
          await tapOn(t, find.byTooltip('Профіль'));
        },
      );
    });
  }
}
