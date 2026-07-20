import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/request_otp.dart';
import '../../../domain/usecases/verify_otp.dart';
import '../../../domain/usecases/create_passkey.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RequestOtp requestOtp;
  final VerifyOtp verifyOtp;
  final CreatePasskey createPasskey;

  RegisterBloc({
    required this.requestOtp,
    required this.verifyOtp,
    required this.createPasskey,
  }) : super(RegisterInitial()) {
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<PasskeyCreationRequested>(_onPasskeyCreationRequested);
    on<PasskeyCreationSkipped>(_onPasskeyCreationSkipped);
  }

  Future<void> _onPhoneNumberSubmitted(
      PhoneNumberSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading(phoneNumber: event.phoneNumber));

    final result = await requestOtp(event.phoneNumber);
    result.fold(
      (failure) => emit(RegisterError(failure.message, phoneNumber: event.phoneNumber)),
      (_) => emit(RegisterStep1Success(phoneNumber: event.phoneNumber)),
    );
  }

  Future<void> _onOtpSubmitted(
      OtpSubmitted event, Emitter<RegisterState> emit) async {
    final phone = state.phoneNumber;
    emit(RegisterLoading(phoneNumber: phone));

    final result = await verifyOtp(phone, event.code);
    result.fold(
      (failure) => emit(RegisterError(failure.message, phoneNumber: phone)),
      (success) {
        if (success) {
          emit(RegisterStep2Success(phoneNumber: phone));
        } else {
          emit(RegisterError('Invalid OTP', phoneNumber: phone));
        }
      },
    );
  }

  Future<void> _onPasskeyCreationRequested(
      PasskeyCreationRequested event, Emitter<RegisterState> emit) async {
    final phone = state.phoneNumber;
    emit(RegisterLoading(phoneNumber: phone));

    final result = await createPasskey(phone);
    result.fold(
      (failure) => emit(RegisterError(failure.message, phoneNumber: phone)),
      (_) => emit(RegisterSuccess(phoneNumber: phone)),
    );
  }

  void _onPasskeyCreationSkipped(
      PasskeyCreationSkipped event, Emitter<RegisterState> emit) {
    // If they skip passkey creation, they are still successfully registered
    emit(RegisterSuccess(phoneNumber: state.phoneNumber));
  }
}
