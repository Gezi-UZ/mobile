import 'package:equatable/equatable.dart';

/// Base class for LED states
abstract class LedState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state
class LedInitial extends LedState {}

/// Loading state
class LedLoading extends LedState {}

/// Success state with LED data
class LedLoaded extends LedState {
  final Map<String, bool> leds;

  LedLoaded({required this.leds});

  @override
  List<Object?> get props => [leds];
}

/// Error state
class LedError extends LedState {
  final String message;

  LedError({required this.message});

  @override
  List<Object?> get props => [message];
}