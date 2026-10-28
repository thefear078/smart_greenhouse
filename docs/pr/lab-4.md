# Лабораторна робота №4 — сесія, MQTT, моніторинг мережі

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-4-integration` → `main`

## MQTT
- **Брокер:** публічний HiveMQ `broker.hivemq.com:1883`
- **Топік:** `lpnu/kb408/yahusevych/greenhouse/#`
  (`…/temperature`, `…/humidity`, `…/soil`, `…/light`)
- **Payload:** число `24.5` або JSON `{"value": 24.5}`
- **Генератор даних:** `tools/mqtt_simulator.py`
  (`pip install paho-mqtt && python tools/mqtt_simulator.py`) або MQTT
  Explorer.
- Пакет `mqtt_client`, сервіс `MqttSensorService` реалізує абстракцію
  `ISensorService` (domain) — віджети працюють лише з нею.
- Перевірено з реальним брокером: опубліковане значення приходить у потік.

## Сесія
- **Автологін:** `main()` перевіряє збережену сесію і відкриває Dashboard,
  минаючи логін.
- **Logout:** діалог підтвердження «Вийти з акаунта?».

## Мережа (`connectivity_plus`, `ConnectivityNetworkMonitor : INetworkMonitor`)
- Логін і реєстрація без інтернету блокуються (SnackBar).
- На головному екрані `NetworkBanner` слухає стан мережі: при втраті —
  червона плашка вгорі, при відновленні — зникає.
- Офлайн-автологін: користувача пускає на Dashboard, але показує діалог
  «Немає підключення» + плашку (обмежений режим).

## Потоки
Усі `StreamSubscription` (`LiveSensorsSection`, `NetworkBanner`)
закриваються в `dispose()`; MQTT-клієнт відключається при виході з екрана.

## Тести
`test/integration_test.dart`: парсинг payload, автологін, офлайн-автологін,
блокування логіну офлайн, потік MQTT → UI, плашка мережі в реальному часі,
діалог виходу (фейкові `FakeNetwork` / `FakeSensors`).

## Відео (записати)
Автологін при перезапуску → діалог logout → симулятор + екран телефона з
даними → вимкнення Wi-Fi/мобільних даних.
