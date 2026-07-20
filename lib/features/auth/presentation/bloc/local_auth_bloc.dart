import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_biometrics_availability.dart';
import '../../domain/usecases/authenticate_with_biometrics.dart';
import 'local_auth_event.dart';
import 'local_auth_state.dart';

class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  final CheckBiometricsAvailability checkBiometricsAvailability;
  final AuthenticateWithBiometrics authenticateWithBiometrics;

  LocalAuthBloc({
    required this.checkBiometricsAvailability,
    required this.authenticateWithBiometrics,
  }) : super(LocalAuthInitial()) {
    on<CheckBiometricsAvailabilityEvent>(_onCheckBiometricsAvailability);
    on<AuthenticateWithBiometricsEvent>(_onAuthenticateWithBiometrics);
  }

  Future<void> _onCheckBiometricsAvailability(
    CheckBiometricsAvailabilityEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    final result = await checkBiometricsAvailability();
    result.fold(
      (failure) => emit(LocalAuthError(message: failure.message)),
      (isAvailable) {
        if (isAvailable) {
          emit(LocalAuthAvailable());
        } else {
          emit(LocalAuthNotAvailable());
        }
      },
    );
  }

  Future<void> _onAuthenticateWithBiometrics(
    AuthenticateWithBiometricsEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    final result = await authenticateWithBiometrics(
      localizedReason: event.localizedReason,
    );
    result.fold(
      (failure) => emit(LocalAuthError(message: failure.message)),
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(LocalAuthenticated());
        } else {
          emit(const LocalAuthError(message: 'Authentication failed'));
        }
      },
    );
  }
}
