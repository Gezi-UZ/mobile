import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure when server communication fails
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Failure when network connection is unavailable
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure when invalid data is provided
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid data provided']);
}

/// Failure when local data/cache encounters an error
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error occurred']);
}

/// Failure specific to Supabase Auth operations
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error']);
}

/// Failure when biometric/local_auth operations fail
class BiometricFailure extends Failure {
  const BiometricFailure([super.message = 'Biometric authentication failed']);
}
