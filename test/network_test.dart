import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_greenhouse/data/cached/cached_device_repository.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/data/remote/api_client.dart';
import 'package:smart_greenhouse/data/remote/remote_device_repository.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/repository_exception.dart';

import 'fakes.dart';

const _json =
    '[{"id":"1","name":"Fan","zone":"A","type":"fan","isOn":true},'
    '{"id":"2","name":"Pump","zone":"B","type":"pump","isOn":false}]';

void main() {
  late LocalDeviceRepository cache;
  late FakeNetwork net;
  var status = 200;
  String? authHeader;

  CachedDeviceRepository repo() {
    final client = MockClient((req) async {
      authHeader = req.headers['Authorization'];
      if (req.method == 'POST') {
        final body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...body, 'id': '9'}), 201);
      }
      return http.Response(_json, status);
    });
    final api = ApiClient(
      baseUrl: 'http://test',
      client: client,
      tokenProvider: () async => 'tkn',
    );
    return CachedDeviceRepository(
      remote: RemoteDeviceRepository(api),
      cache: cache,
      network: net,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    cache = LocalDeviceRepository(await JsonStore.create(), withSeed: false);
    net = FakeNetwork();
    status = 200;
  });

  test('online: fetches, parses JSON, sends token, saves cache', () async {
    final list = await repo().getAll();
    expect(list.map((d) => d.name), ['Fan', 'Pump']);
    expect(list.first.type, DeviceType.fan);
    expect(authHeader, 'Bearer tkn');
    expect((await cache.readCache()).length, 2);
  });

  test('offline: returns cached data without error', () async {
    await repo().getAll();
    net.online = false;
    final r = repo();
    expect((await r.getAll()).length, 2);
    expect(r.servedFromCache, isTrue);
  });

  test('server error falls back to cache; empty cache -> exception', () async {
    status = 500;
    await expectLater(repo().getAll(), throwsA(isA<ApiException>()));
    status = 200;
    await repo().getAll();
    status = 503;
    expect((await repo().getAll()).length, 2);
  });

  test('add goes to server and cache; offline add is blocked', () async {
    final d = await repo().add(name: 'Lamp', zone: 'C', type: DeviceType.lamp);
    expect(d.id, '9');
    expect((await cache.readCache()).single.name, 'Lamp');
    net.online = false;
    await expectLater(
      repo().add(name: 'X', zone: 'Y', type: DeviceType.fan),
      throwsA(isA<RepositoryException>()),
    );
  });
}
