import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';
import 'package:smart_greenhouse/domain/services/flashlight_service.dart';

/// [IFlashlight] на основі власного плагіна my_flashlight_plugin.
/// Застосунок імпортує лише Dart-інтерфейс плагіна (без MethodChannel).
class PluginFlashlight implements IFlashlight {
  @override
  Future<bool> toggle() async {
    try {
      return await MyFlashlightPlugin.toggle();
    } on FlashlightException catch (e) {
      throw FlashlightFailure(e.message);
    }
  }
}
