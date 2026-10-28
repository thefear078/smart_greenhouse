# Smart Greenhouse 🌱

IoT-застосунок для моніторингу та керування «розумною» теплицею: датчики
температури, вологості повітря й ґрунту, освітленості та виконавчі пристрої
(вентилятори, насоси поливу, фітолампи).

Лабораторні роботи з дисципліни «Розроблення мобільних додатків».
Студент: **Ягусевич Костянтин Костянтинович**, група КБ-408.

## Гілки

| Гілка | Лабораторна | Тема |
|---|---|---|
| `main` | — | базовий шаблон, лінтер, CI |
| `feature/lab-1-counter` | №1 | інтерактивний лічильник, валідація, `setState` |
| `feature/lab-2-ui` | №2 | екрани, кастомні віджети, навігація, адаптивність |
| `feature/lab-3-logic` | №3 | авторизація, валідація, локальне сховище, CRUD |
| `feature/lab-4-integration` | №4 | автологін, logout-діалог, MQTT, моніторинг мережі |
| `feature/lab-5-network` | №5 | REST API, FutureBuilder, офлайн-кеш |
| `feature/lab-6-state-management` | №6 | Cubit (flutter_bloc), get_it, StatelessWidget |
| `feature/lab-7-native` | №7 | власний плагін ліхтарика (Kotlin), Easter egg |

## Запуск

```bash
flutter pub get
flutter run
```

Перевірки (ті самі, що в CI `.github/workflows/validation.yaml`):

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test
```
