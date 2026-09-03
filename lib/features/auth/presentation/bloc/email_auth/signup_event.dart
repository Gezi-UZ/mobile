import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupRequested extends SignupEvent {
  final String fullName;
  final String email;
  final String pin;

  const SignupRequested({
    required this.fullName,
    required this.email,
    required this.pin,
  });

  @override
  List<Object> get props => [fullName, email, pin];
}
