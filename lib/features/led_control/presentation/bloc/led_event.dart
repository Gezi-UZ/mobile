import 'package:equatable/equatable.dart';

/// Base class for LED events
abstract class LedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to load all LED states
class LoadAllLedsEvent extends LedEvent {}

/// Event to toggle a specific LED
class ToggleLedEvent extends LedEvent {
  final String ledId;
  final bool state;

  ToggleLedEvent({required this.ledId, required this.state});

  @override
  List<Object?> get props => [ledId, state];
}
