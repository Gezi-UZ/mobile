import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/get_my_meters.dart';
import '../../domain/usecases/edit_meter.dart';
import '../../domain/usecases/register_meter.dart';
import '../../domain/usecases/validate_meter_by_serial.dart';
import '../../domain/usecases/watch_user_meters.dart';
import 'meter_event.dart';
import 'meter_state.dart';

class MeterBloc extends Bloc<MeterEvent, MeterState> {
  final GetMyMeters getMyMeters;
  final EditMeter editMeter;
  final RegisterMeter registerMeter;
  final ValidateMeterBySerial validateMeterBySerial;
  final WatchUserMeters watchUserMeters;

  StreamSubscription? _metersSubscription;

  MeterBloc({
    required this.getMyMeters,
    required this.editMeter,
    required this.registerMeter,
    required this.validateMeterBySerial,
    required this.watchUserMeters,
  }) : super(const MeterInitial()) {
    on<MeterListRequested>(_onListRequested);
    on<MeterSetPrimaryRequested>(_onSetPrimaryRequested);
    on<MeterUpdatedRealtime>(_onUpdatedRealtime);
    on<MeterValidateRequested>(_onValidateRequested);
    on<MeterAddRequested>(_onAddRequested);
    on<MeterUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onListRequested(
    MeterListRequested event,
    Emitter<MeterState> emit,
  ) async {
    emit(const MeterLoading());
    final result = await getMyMeters(NoParams());
    result.fold(
      (failure) => emit(MeterError(message: failure.message)),
      (meters) {
        emit(MeterLoaded(meters: meters));
        _subscribeToRealtime();
      },
    );
  }

  void _subscribeToRealtime() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    _metersSubscription?.cancel();
    _metersSubscription = watchUserMeters(userId).listen(
      (meters) {
        add(MeterUpdatedRealtime(meters));
      },
      onError: (_) {
        // Silently ignore realtime connection drops; next manual fetch will refresh
      },
    );
  }

  final Set<String> _notifiedMeters = {};

  void _onUpdatedRealtime(
    MeterUpdatedRealtime event,
    Emitter<MeterState> emit,
  ) {
    emit(MeterLoaded(meters: event.meters));

    for (final meter in event.meters) {
      if (meter.kwhBalance < 5.0) {
        if (!_notifiedMeters.contains(meter.id)) {
          sl<LocalNotificationService>().showLowBalanceNotification(meter.kwhBalance);
          _notifiedMeters.add(meter.id);
        }
      } else {
        _notifiedMeters.remove(meter.id);
      }
    }
  }

  Future<void> _onSetPrimaryRequested(
    MeterSetPrimaryRequested event,
    Emitter<MeterState> emit,
  ) async {
    final currentState = state;
    if (currentState is MeterLoaded) {
      // Optimistic update
      final updated = currentState.meters.map((m) {
        return m.copyWith(isPrimary: m.id == event.meterId);
      }).toList();
      emit(MeterLoaded(meters: updated));

      final result = await editMeter(EditMeterParams(
        meterId: event.meterId,
        isPrimary: true,
      ));

      result.fold(
        (failure) {
          // Rollback on failure
          emit(currentState);
          emit(MeterError(message: failure.message));
        },
        (_) {
          // Success
        },
      );
    }
  }

  Future<void> _onValidateRequested(
    MeterValidateRequested event,
    Emitter<MeterState> emit,
  ) async {
    emit(const MeterValidating());
    final result = await validateMeterBySerial(
      ValidateMeterParams(serialNumber: event.serialNumber),
    );
    result.fold(
      (failure) => emit(MeterValidationFailure(message: failure.message)),
      (meter) => emit(MeterValidationSuccess(meter: meter)),
    );
  }

  Future<void> _onAddRequested(
    MeterAddRequested event,
    Emitter<MeterState> emit,
  ) async {
    emit(const MeterLoading());
    final result = await registerMeter(RegisterMeterParams(
      serialNumber: event.serialNumber,
      alias: event.alias,
      latitude: event.latitude,
      longitude: event.longitude,
      address: event.address,
    ));

    result.fold(
      (failure) => emit(MeterError(message: failure.message)),
      (_) {
        add(const MeterListRequested());
      },
    );
  }

  Future<void> _onUpdateRequested(
    MeterUpdateRequested event,
    Emitter<MeterState> emit,
  ) async {
    emit(const MeterLoading());
    final result = await editMeter(EditMeterParams(
      meterId: event.meterId,
      alias: event.alias,
      isPrimary: event.isPrimary,
    ));

    result.fold(
      (failure) => emit(MeterError(message: failure.message)),
      (_) {
        add(const MeterListRequested());
      },
    );
  }

  @override
  Future<void> close() {
    _metersSubscription?.cancel();
    return super.close();
  }
}

