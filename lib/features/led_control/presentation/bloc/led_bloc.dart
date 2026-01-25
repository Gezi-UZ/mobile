import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecases.dart';
import '../../domain/usecases/get_all_leds.dart';
import '../../domain/usecases/toggle_led.dart';
import 'led_event.dart';
import 'led_state.dart';

class LedBloc extends Bloc<LedEvent, LedState> {
  final GetAllLeds getAllLeds;
  final ToggleLed toggleLed;

  LedBloc({required this.getAllLeds, required this.toggleLed})
    : super(LedInitial()) {
    on<LoadAllLedsEvent>(_onLoadAllLeds);
    on<ToggleLedEvent>(_onToggleLed);
  }

  Future<void> _onLoadAllLeds(
    LoadAllLedsEvent event,
    Emitter<LedState> emit,
  ) async {
    // Only show loading if we don't have data yet
    if (state is! LedLoaded) {
      emit(LedLoading());
    }

    final result = await getAllLeds(NoParams());

    result.fold(
      (failure) => emit(LedError(message: failure.message)),
      (leds) => emit(LedLoaded(leds: leds)),
    );
  }

  Future<void> _onToggleLed(
    ToggleLedEvent event,
    Emitter<LedState> emit,
  ) async {
    final currentState = state;

    // Optimistic update
    if (currentState is LedLoaded) {
      final updatedLeds = Map<String, bool>.from(currentState.leds);
      updatedLeds[event.ledId] = event.state;
      emit(LedLoaded(leds: updatedLeds));
    } else {
      emit(LedLoading());
    }

    final result = await toggleLed(
      ToggleLedParams(ledId: event.ledId, state: event.state),
    );

    result.fold(
      (failure) {
        emit(LedError(message: failure.message));
        // Restore previous state after error
        if (currentState is LedLoaded) {
          emit(currentState);
        }
      },
      (_) {
        // Sync with server to ensure consistency
        add(LoadAllLedsEvent());
      },
    );
  }
}
