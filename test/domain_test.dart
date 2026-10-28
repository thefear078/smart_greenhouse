import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/validators.dart';

void main() {
  group('Validators', () {
    test('email', () {
      expect(Validators.email('user@mail.com'), isNull);
      expect(Validators.email('usermail.com'), contains('@'));
      expect(Validators.email('user@mail'), isNotNull);
    });
    test('password >= 8', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });
    test('name without digits', () {
      expect(Validators.name('Kostia'), isNull);
      expect(Validators.name('Kostia2'), contains('цифр'));
    });
  });

  group('Local repositories', () {
    late JsonStore store;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      store = await JsonStore.create();
    });

    test('register, login, duplicate, wrong password', () async {
      final auth = LocalAuthRepository(store);
      await auth.register(name: 'Ann', email: 'A@b.com', password: 'pass1234');
      await auth.logout();
      expect(await auth.currentUser(), isNull);
      final user = await auth.login(email: 'a@b.com', password: 'pass1234');
      expect(user.name, 'Ann');
      expect(user.passwordHash, isNot('pass1234'));
      expect(
        () => auth.register(name: 'X', email: 'a@b.com', password: '12345678'),
        throwsA(isA<AuthException>()),
      );
      expect(
        () => auth.login(email: 'a@b.com', password: 'wrongpass'),
        throwsA(isA<AuthException>()),
      );
    });

    test('device CRUD persists', () async {
      final repo = LocalDeviceRepository(store);
      final seeded = (await repo.getAll()).length;
      final d = await repo.add(name: 'Pump', zone: 'Z', type: DeviceType.pump);
      await repo.update(d.copyWith(isOn: true));
      final again = LocalDeviceRepository(store);
      final list = await again.getAll();
      expect(list.length, seeded + 1);
      expect(list.last.isOn, isTrue);
      await again.delete(d.id);
      expect((await again.getAll()).length, seeded);
    });
  });
}
