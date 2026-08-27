import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/sign_up.dart';
import '../../../domain/usecases/authenticate_with_biometrics.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Manages the multi-step registration flow:
///
/// Step 1 — Phone number → Supabase signUp (no OTP)
/// Step 2 — Passkey setup (fingerprint or PIN via local_auth)
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUp signUp;
  final AuthenticateWithBiometrics authenticateWithBiometrics;
  final AuthRepository authRepository;

  RegisterBloc({
    required this.signUp,
    required this.authenticateWithBiometrics,
    required this.authRepository,
  }) : super(RegisterInitial()) {
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<PasskeyCreationRequested>(_onPasskeyCreationRequested);
    on<PasskeyCreationSkipped>(_onPasskeyCreationSkipped);
  }

  // ─────────────────────────────────────────────────────────────────
  // Step 1 — Sign up with phone
  // ─────────────────────────────────────────────────────────────────

  Future<void> _onPhoneNumberSubmitted(
    PhoneNumberSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading(phoneNumber: event.phoneNumber));

    final result = await signUp(event.phoneNumber);
    result.fold(
      (failure) => emit(RegisterError(failure.message, phoneNumber: event.phoneNumber)),
      (session) => emit(
        RegisterStep1Success(phoneNumber: event.phoneNumber, session: session),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Step 2 — Enable biometric passkey
  // ─────────────────────────────────────────────────────────────────

  Future<void> _onPasskeyCreationRequested(
    PasskeyCreationRequested event,
    Emitter<RegisterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RegisterStep1Success) return;

    emit(RegisterLoading(phoneNumber: currentState.phoneNumber));

    // Trigger device biometric prompt
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
            'Autenticação biométrica falhou. Tente novamente.',
            phoneNumber: currentState.phoneNumber,
          ));
          return;
        }

        // Store refresh token in secure storage + update Supabase user_metadata
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
  // Step 2 skipped
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
