import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends LoginEvent {
  final String email;
  final String pin;

  const LoginRequested({required this.email, required this.pin});

  @override
  List<Object> get props => [email, pin];
}
