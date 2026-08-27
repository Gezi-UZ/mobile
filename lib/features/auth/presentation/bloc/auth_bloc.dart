import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/supabase/supabase_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/sign_in_with_biometric.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Global auth bloc that lives for the lifetime of the app.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentSession getCurrentSession;
  final SignInWithBiometric signInWithBiometric;
  final SignOut signOut;
  final AuthRepository authRepository;

  StreamSubscription<sb.AuthState>? _authSubscription;

  AuthBloc({
    required this.getCurrentSession,
    required this.signInWithBiometric,
    required this.signOut,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<PinLoginRequested>(_onPinLoginRequested);
    on<SessionObtained>(_onSessionObtained);
    on<SignOutRequested>(_onSignOutRequested);

    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == sb.AuthChangeEvent.signedIn && session != null) {
        add(const AppStarted());
      } else if (event == sb.AuthChangeEvent.signedOut) {
        add(const SignOutRequested());
      } else if (event == sb.AuthChangeEvent.tokenRefreshed && session != null) {
        add(const AppStarted());
      }
    });
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentSession();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (session) {
        if (session != null) {
          emit(AuthAuthenticated(session));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInWithBiometric();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> _onPinLoginRequested(
    PinLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.verifyPin(event.pin);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  void _onSessionObtained(
    SessionObtained event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAuthenticated(event.session));
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
