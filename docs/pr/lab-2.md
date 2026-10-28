# Лабораторна робота №2 — UI, кастомні віджети, навігація

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-2-ui` → `main`
**Тема застосунку (IoT):** Smart Greenhouse — моніторинг і керування теплицею.

## Екрани (`lib/screens/`)
| Екран | Вміст |
|---|---|
| `LoginScreen` | email, пароль, вхід, перехід до реєстрації |
| `RegistrationScreen` | ім'я, email, пароль, підтвердження |
| `DashboardScreen` | банер теплиці, сітка датчиків, список пристроїв |
| `ProfileScreen` | аватар з ініціалами, дані акаунта, редагування, вихід |

## Кастомні віджети (`lib/widgets/`)
`AppTextField`, `PrimaryButton` (з індикатором завантаження), `AuthLayout`
(спільний каркас авторизації), `AppLogo`, `SensorCard`, `DeviceTile`,
`SectionHeader`, `GreenhouseHeader`, `InfoRow`, `ProfileAvatar`,
`ResponsiveGrid` (LayoutBuilder → 1–4 колонки), `PageContainer`
(MediaQuery, обмеження ширини).

## Архітектура
- Маршрутизація: іменовані маршрути `AppRoutes` (`pushNamed`,
  `pushReplacementNamed`, `pushNamedAndRemoveUntil`, `pop`).
- Дизайн-система: `lib/theme/app_theme.dart` — палітра, відступи, радіуси.
- Mock-дані: `lib/data/mock_data.dart`.
- Найбільший файл < 120 рядків; лінтер — 0 зауважень.
- Тести: навігація між усіма екранами, відсутність overflow на 375 dp і
  1024 dp.

## Скріншоти
Телефон (390 dp) і планшет (1024 dp): `screenshot_test/goldens/`
(перегенерувати: `flutter test screenshot_test --update-goldens`).
Відео навігації — записати з емулятора.
