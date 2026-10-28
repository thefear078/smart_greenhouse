# Лабораторна робота №5 — REST API, FutureBuilder, офлайн-кеш

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-5-network` → `main`

## Бекенд
- REST-ресурс `/devices` (GET / POST / PUT / DELETE, JSON).
- Для розробки — `tools/mock_api_server.py` (Python, без залежностей):
  `python tools/mock_api_server.py` → `http://localhost:8080/devices`.
  Емулятор Android ходить на `http://10.0.2.2:8080` (адреса за
  замовчуванням).
- Інший сервер (MockAPI.io, власний бекенд):
  `flutter run --dart-define=API_URL=https://<host>`.

## Мережевий шар (`lib/data/remote/`)
- `ApiClient` (пакет `http`): JSON, таймаут 8 с, заголовок
  `Authorization: Bearer <token>` (**бонус: token-based авторизація** —
  токен створюється при логіні й зберігається локально).
- Кожен запит у `try-catch`; будь-який статус ≠ 2xx, таймаут, відсутність
  з'єднання, некоректний JSON → `ApiException` (успадковує доменний
  `RepositoryException`, який показує UI).
- `DeviceDto` + мапери `toDomain()` / `toDto()`; `fromJson` / `toJson`.
- `RemoteDeviceRepository implements IDeviceRepository` — той самий
  інтерфейс, що й локальний репозиторій з лаб. №3 (поліморфізм; UI не
  змінювався).

## Offline-First (`CachedDeviceRepository`)
мережа → збереження в локальне сховище → UI; немає мережі або помилка
сервера → останні збережені дані без помилки. Зміни в офлайні заборонені
(повідомлення «зміни недоступні в офлайн-режимі»). Профіль користувача
зберігається локально (`LocalAuthRepository`), автологін — через локальну
сесію.

## UI
`FutureBuilder` на Dashboard: Loading (індикатор), Success (список),
Error (`ErrorRetry` з кнопкою «Повторити»), кнопка «Оновити» в AppBar.
Жоден файл не перевищує 150 рядків.

## Тести
`test/network_test.dart` (`MockClient`): парсинг JSON, токен у заголовку,
запис у кеш, офлайн-читання з кешу, fallback при 5xx, блокування змін
офлайн. Додатково перевірено вручну проти запущеного mock-сервера.
