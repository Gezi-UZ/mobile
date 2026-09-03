import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_with_email.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpWithEmail signUpWithEmail;

  SignupBloc({required this.signUpWithEmail}) : super(SignupInitial()) {
    on<SignupRequested>(_onSignupRequested);
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    final result = await signUpWithEmail(
      fullName: event.fullName,
      email: event.email,
      pin: event.pin,
    );

    result.fold(
      (failure) => emit(SignupFailure(failure.message)),
      (session) => emit(SignupSuccess(session)),
    );
  }
}
