import 'package:equatable/equatable.dart';
import '../../../domain/entities/session.dart';

abstract class RegisterState extends Equatable {
  final String phoneNumber;

  const RegisterState({this.phoneNumber = ''});

  @override
  List<Object?> get props => [phoneNumber];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {
  const RegisterLoading({super.phoneNumber});
}

/// Step 1 complete — account created, session obtained.
class RegisterStep1Success extends RegisterState {
  final UserSession session;

  const RegisterStep1Success({required super.phoneNumber, required this.session});

  @override
  List<Object?> get props => [phoneNumber, session];
}

/// Registration fully complete (passkey created or skipped).
class RegisterSuccess extends RegisterState {
  final UserSession session;

  const RegisterSuccess({required super.phoneNumber, required this.session});

  @override
  List<Object?> get props => [phoneNumber, session];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message, {super.phoneNumber});

  @override
  List<Object?> get props => [message, phoneNumber];
}
