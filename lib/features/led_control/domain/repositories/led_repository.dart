import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/led.dart';

/// LED Repository Contract
abstract class LedRepository {
  /// Get all LED states from ESP32
  Future<Either<Failure, Map<String, bool>>> getAllLeds();

  /// Get single LED state by ID
  Future<Either<Failure, Led>> getLed(String ledId);

  /// Set LED state (on/off)
  Future<Either<Failure, Led>> setLed(String ledId, bool state);
}