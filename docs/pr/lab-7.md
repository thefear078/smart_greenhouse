# Лабораторна робота №7 — власний нативний плагін ліхтарика

**Студент:** Ягусевич Костянтин Костянтинович, КБ-408
**Гілка:** `feature/lab-7-native` → `main`
**Репозиторій плагіна:** https://github.com/thefear078/my_flashlight_plugin

## Плагін `my_flashlight_plugin` (окремий репозиторій)
- Створено `flutter create --template=plugin --platforms=android,ios -a kotlin -i swift`.
- **Android (Kotlin):** `CameraManager.setTorchMode`; перед викликом —
  перевірка `FEATURE_CAMERA_FLASH` і `FLASH_INFO_AVAILABLE`, перехоплення
  `CameraAccessException` / `IllegalArgumentException` → помилка `NO_FLASH`
  замість падіння (stress test на емуляторі/планшеті без спалаху).
- **Публічний API:** статичний `MyFlashlightPlugin.toggle()`, а також
  `isAvailable()`, `isPlatformSupported`.
- **Graceful degradation:** на iOS / Web канал не викликається, кидається
  `FlashlightUnsupportedException` з назвою платформи.
- Увесь код `MethodChannel` — лише в плагіні; тести з мок-каналом.

## Інтеграція в застосунок
- `pubspec.yaml`: залежність через **git URL** (не локальний шлях).
  Для локальної розробки до push — `pubspec_overrides.yaml` (у `.gitignore`).
- Абстракція `IFlashlight` (domain) → `PluginFlashlight` (data) →
  `FlashlightCubit` (logic). У застосунку немає жодного `MethodChannel`.
- **Easter egg:** довге натискання на іконку теплиці в банері головного
  екрана вмикає/вимикає ліхтарик; результат або помилка — у SnackBar.

## Тести
`test/flashlight_test.dart`: Easter egg вмикає ліхтарик, пристрій без
спалаху → повідомлення без винятку, iOS → `FlashlightFailure`.
У плагіні: `test/my_flashlight_plugin_test.dart` (Android toggle, NO_FLASH, iOS).

## Відео (записати на реальному Android-телефоні)
Довге натискання на логотип → ліхтарик вмикається/вимикається.
