import '../../domain/entities/led.dart';

/// LED Model - Data layer representation with JSON serialization
class LedModel extends Led {
  const LedModel({
    required super.id,
    required super.state,
  });

  /// Create from JSON
  factory LedModel.fromJson(Map<String, dynamic> json) {
    return LedModel(
      id: json['id'] as String,
      state: json['state'] as bool,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
    };
  }

  /// Convert from Entity
  factory LedModel.fromEntity(Led led) {
    return LedModel(
      id: led.id,
      state: led.state,
    );
  }
}