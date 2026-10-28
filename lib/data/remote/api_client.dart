import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_greenhouse/domain/repositories/repository_exception.dart';

/// Помилка мережевого запиту (не-2xx статус, таймаут, немає з'єднання).
class ApiException extends RepositoryException {
  const ApiException(super.message, {this.statusCode});

  final int? statusCode;

  @override
  String toString() =>
      statusCode == null ? message : 'HTTP $statusCode: $message';
}

/// HTTP-клієнт REST API: JSON, таймаут, Bearer-токен, обробка помилок.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.tokenProvider,
    this.timeout = const Duration(seconds: 8),
  }) : _client = client ?? http.Client();

  /// Адреса API; задається через --dart-define=API_URL=...
  /// За замовчуванням — локальний mock-сервер (10.0.2.2 = хост для
  /// Android-емулятора).
  static const String defaultBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  final String baseUrl;
  final http.Client _client;
  final Future<String?> Function()? tokenProvider;
  final Duration timeout;

  Future<Object?> get(String path) => _send('GET', path);

  Future<Object?> post(String path, Object body) =>
      _send('POST', path, body: body);

  Future<Object?> put(String path, Object body) =>
      _send('PUT', path, body: body);

  Future<Object?> delete(String path) => _send('DELETE', path);

  Future<Object?> _send(String method, String path, {Object? body}) async {
    final token = await tokenProvider?.call();
    final request = http.Request(method, Uri.parse('$baseUrl$path'))
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
    if (body != null) request.body = jsonEncode(body);
    try {
      final streamed = await _client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          response.reasonPhrase ?? 'Помилка сервера',
          statusCode: response.statusCode,
        );
      }
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } on TimeoutException {
      throw const ApiException('Сервер не відповідає');
    } on SocketException {
      throw const ApiException('Немає з\'єднання з сервером');
    } on http.ClientException catch (e) {
      throw ApiException(e.message);
    } on FormatException {
      throw const ApiException('Некоректна відповідь сервера');
    }
  }
}
