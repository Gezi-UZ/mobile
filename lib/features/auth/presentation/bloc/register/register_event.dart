import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class PhoneNumberSubmitted extends RegisterEvent {
  final String phoneNumber;

  const PhoneNumberSubmitted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpSubmitted extends RegisterEvent {
  final String code;

  const OtpSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

class PasskeyCreationRequested extends RegisterEvent {
  final String method;

  const PasskeyCreationRequested({this.method = 'fingerprint'});

  @override
  List<Object?> get props => [method];
}

class PasskeyCreationSkipped extends RegisterEvent {}
