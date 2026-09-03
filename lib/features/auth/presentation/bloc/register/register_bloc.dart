import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/authenticate_with_biometrics.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Manages the passkey setup step after OTP authentication.
///
/// Flow:
///   OtpVerifiedForRegister → RegisterStep1Success (session available)
///   PasskeyCreationRequested → biometric prompt → RegisterSuccess
///   PasskeyCreationSkipped   → RegisterSuccess (no passkey)
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticateWithBiometrics authenticateWithBiometrics;
  final AuthRepository authRepository;

  RegisterBloc({
    required this.authenticateWithBiometrics,
    required this.authRepository,
  }) : super(RegisterInitial()) {
    on<OtpVerifiedForRegister>(_onOtpVerified);
    on<PasskeyCreationRequested>(_onPasskeyCreationRequested);
    on<PasskeyCreationSkipped>(_onPasskeyCreationSkipped);
  }

  // ─────────────────────────────────────────────────────────────────
  // OTP Verified — session received, ready for passkey setup
  // ─────────────────────────────────────────────────────────────────

  void _onOtpVerified(
    OtpVerifiedForRegister event,
    Emitter<RegisterState> emit,
  ) {
    emit(RegisterStep1Success(
      phoneNumber: event.phoneNumber,
      session: event.session,
    ));
  }

  // ─────────────────────────────────────────────────────────────────
  // Passkey — Enable biometric
  // ─────────────────────────────────────────────────────────────────

  Future<void> _onPasskeyCreationRequested(
    PasskeyCreationRequested event,
    Emitter<RegisterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RegisterStep1Success) return;

    emit(RegisterLoading(phoneNumber: currentState.phoneNumber));

    final bioResult = await authenticateWithBiometrics(
      localizedReason: 'Confirme a sua identidade para criar a sua Passkey Gezi',
    );

    await bioResult.fold(
      (failure) async => emit(
        RegisterError(failure.message, phoneNumber: currentState.phoneNumber),
      ),
      (authenticated) async {
        if (!authenticated) {
          emit(RegisterError(
            'Autenticacao biometrica falhou. Tente novamente.',
            phoneNumber: currentState.phoneNumber,
          ));
          return;
        }

        final enableResult =
            await authRepository.enableBiometric(currentState.session);

        enableResult.fold(
          (failure) => emit(
            RegisterError(failure.message, phoneNumber: currentState.phoneNumber),
          ),
          (_) => emit(
            RegisterSuccess(
              phoneNumber: currentState.phoneNumber,
              session: currentState.session,
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Passkey skipped
  // ─────────────────────────────────────────────────────────────────

  void _onPasskeyCreationSkipped(
    PasskeyCreationSkipped event,
    Emitter<RegisterState> emit,
  ) {
    final currentState = state;
    if (currentState is RegisterStep1Success) {
      emit(RegisterSuccess(
        phoneNumber: currentState.phoneNumber,
        session: currentState.session,
      ));
    }
  }
}
