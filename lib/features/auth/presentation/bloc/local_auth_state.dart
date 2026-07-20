import 'package:equatable/equatable.dart';

abstract class LocalAuthState extends Equatable {
  const LocalAuthState();

  @override
  List<Object> get props => [];
}

class LocalAuthInitial extends LocalAuthState {}

class LocalAuthLoading extends LocalAuthState {}

class LocalAuthAvailable extends LocalAuthState {}

class LocalAuthNotAvailable extends LocalAuthState {}

class LocalAuthenticated extends LocalAuthState {}

class LocalAuthError extends LocalAuthState {
  final String message;

  const LocalAuthError({required this.message});

  @override
  List<Object> get props => [message];
}
