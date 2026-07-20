import 'package:equatable/equatable.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object> get props => [];
}

class CheckBiometricsAvailabilityEvent extends LocalAuthEvent {}

class AuthenticateWithBiometricsEvent extends LocalAuthEvent {
  final String localizedReason;

  const AuthenticateWithBiometricsEvent({this.localizedReason = 'Toque no sensor de impressão digital para entrar'});

  @override
  List<Object> get props => [localizedReason];
}
