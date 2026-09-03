import 'package:equatable/equatable.dart';
import '../../../domain/entities/session.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// OTP was verified — provides the session so passkey setup can proceed.
class OtpVerifiedForRegister extends RegisterEvent {
  final String phoneNumber;
  final UserSession session;

  const OtpVerifiedForRegister({
    required this.phoneNumber,
    required this.session,
  });

  @override
  List<Object?> get props => [phoneNumber, session];
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
