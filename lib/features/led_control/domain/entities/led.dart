import 'package:equatable/equatable.dart';

class Led extends Equatable {
  final String id;
  final bool state;

  const Led({
    required this.id,
    required this.state,
  });

  Led copyWith({
    String? id,
    bool? state,
  }) {
    return Led(
      id: id ?? this.id,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [id, state];
}