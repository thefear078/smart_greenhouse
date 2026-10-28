# Лабораторна робота №6 — State Management (Cubit) + DI

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-6-state-management` → `main`

## Інструменти
- **flutter_bloc (Cubit)** — односпрямований потік даних:
  UI → метод Cubit → Repository → новий State → BlocBuilder перемальовує UI.
- **get_it** — DI-контейнер (`lib/di/injector.dart`): репозиторії, API-клієнт,
  MQTT і мережевий сервіси — singleton; Cubit-и екранів — factory.
- **equatable** — імутабельні стани з порівнянням за значенням.

## Cubit-и (`lib/logic/`)
| Cubit | Стан | Відповідальність |
|---|---|---|
| `AuthCubit` (глобальний) | `AuthState {status, user, message}` | вхід, реєстрація, профіль, вихід, блокування офлайн |
| `NetworkCubit` (глобальний) | `NetworkState {online, checked}` | стан мережі, підписка закривається в `close()` |
| `DevicesCubit` (екран) | `DevicesState {status, devices, error, notice}` | CRUD пристроїв |
| `TelemetryCubit` (екран) | `TelemetryState {status, latest}` | потік MQTT; відключення в `close()` |

## Архітектурні вимоги
- **95 % StatelessWidget.** Лишилось 4 StatefulWidget — лише для
  `TextEditingController` (форми логіну/реєстрації, діалоги).
- **UI is dumb:** жоден віджет не імпортує репозиторії/API; `AppScope`
  видалено. CRUD, список і помилки — реакція на стан (`BlocBuilder`,
  `BlocConsumer`), `FutureBuilder` замінено.
- **Singleton/DI:** `new Repository()` лише в `injector.dart`.
- Автологін — на рівні точки входу (`main` → `hasSession`).
- Жоден файл не перевищує 150 рядків.

## Тести
`test/cubit_test.dart` — singleton-и, AuthCubit (офлайн/реєстрація/вихід),
DevicesCubit (CRUD), TelemetryCubit (потік → стан, відключення при close).
Усі попередні віджет-тести проходять через DI з фейками: 20/20.
