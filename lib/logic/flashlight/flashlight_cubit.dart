import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/services/flashlight_service.dart';

class FlashlightState extends Equatable {
  const FlashlightState({this.isOn = false, this.message, this.eventId = 0});

  final bool isOn;

  /// Повідомлення для користувача після останньої спроби.
  final String? message;
  final int eventId;

  @override
  List<Object?> get props => [isOn, message, eventId];
}

/// Easter egg: прихований перемикач ліхтарика.
class FlashlightCubit extends Cubit<FlashlightState> {
  FlashlightCubit(this._flashlight) : super(const FlashlightState());

  final IFlashlight _flashlight;

  Future<void> toggle() async {
    final next = state.eventId + 1;
    try {
      final on = await _flashlight.toggle();
      emit(
        FlashlightState(
          isOn: on,
          message: on ? '🔦 Ліхтарик увімкнено' : 'Ліхтарик вимкнено',
          eventId: next,
        ),
      );
    } on FlashlightFailure catch (e) {
      emit(
        FlashlightState(isOn: state.isOn, message: e.message, eventId: next),
      );
    }
  }
}
