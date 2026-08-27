import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// Step 1 — User submits their phone number and we sign them up directly.
class PhoneNumberSubmitted extends RegisterEvent {
  final String phoneNumber;

  const PhoneNumberSubmitted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Step 2 — User chooses their passkey method (fingerprint or PIN).
class PasskeyCreationRequested extends RegisterEvent {
  final String method;

  const PasskeyCreationRequested({this.method = 'fingerprint'});

  @override
  List<Object?> get props => [method];
}

/// Step 2 alt — User skips passkey setup for now.
class PasskeyCreationSkipped extends RegisterEvent {}
