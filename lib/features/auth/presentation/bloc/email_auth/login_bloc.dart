import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_in_with_email.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInWithEmail signInWithEmail;

  LoginBloc({required this.signInWithEmail}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await signInWithEmail(email: event.email, pin: event.pin);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (session) => emit(LoginSuccess(session)),
    );
  }
}
