# Лабораторна робота №3 — бізнес-логіка, авторизація, локальне сховище, CRUD

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-3-logic` → `main`

## Стек зберігання даних
- `shared_preferences` — key-value сховище; дані серіалізуються в JSON
  (`JsonStore`).
- `crypto` (SHA-256) — пароль зберігається лише як хеш.

## Шари
```
lib/
├── domain/          абстракції та бізнес-правила
│   ├── models/      User, Device (імутабельні, copyWith, toJson/fromJson)
│   ├── repositories/IAuthRepository, IDeviceRepository (+ AuthException)
│   └── validators.dart
├── data/local/      JsonStore, LocalAuthRepository, LocalDeviceRepository
└── ui/              екрани, віджети, тема, маршрути, AppScope (DI)
```
- **Dependency Inversion:** UI бачить лише `IAuthRepository` /
  `IDeviceRepository` через `AppScope` (InheritedWidget). Конкретні
  реалізації створюються один раз у `main.dart` — заміна на REST API не
  вимагає змін в UI.
- Стан на UI — `StatefulWidget` + `setState`; асинхронні виклики
  (`async/await`) з `CircularProgressIndicator`.

## Функціонал
- **Реєстрація** з валідацією: email (`@` + домен), пароль ≥ 8 символів,
  ім'я без цифр, підтвердження пароля; зайнятий email → помилка.
- **Логін**: звірка з локальним сховищем; успіх → Dashboard, помилка →
  SnackBar «Невірний email або пароль».
- **CRUD пристроїв** на Dashboard: додати (FAB + діалог), редагувати (тап),
  увімкнути/вимкнути (Switch), видалити (з підтвердженням).
- **Профіль**: дані авторизованого користувача, зміна імені, вихід.

## Тести
`test/domain_test.dart` (валідатори, репозиторії, збереження після
«перезапуску»), `test/widget_test.dart` (невдала/вдала реєстрація, CRUD,
невдалий/вдалий логін). `flutter analyze` — 0 зауважень.

## Відео (записати)
Невдала й успішна реєстрація → невдалий/успішний логін → додавання,
редагування, видалення пристрою → перезапуск застосунку (дані збережені).
