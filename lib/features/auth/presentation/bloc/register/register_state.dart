import 'package:equatable/equatable.dart';

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

class RegisterStep1Success extends RegisterState {
  const RegisterStep1Success({super.phoneNumber});
}

class RegisterStep2Success extends RegisterState {
  const RegisterStep2Success({super.phoneNumber});
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({super.phoneNumber});
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message, {super.phoneNumber});

  @override
  List<Object?> get props => [message, phoneNumber];
}
