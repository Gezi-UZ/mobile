import 'package:equatable/equatable.dart';

/// Represents an authenticated user session obtained from Supabase Auth.
class UserSession extends Equatable {
  final String userId;
  final String? phone;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final bool isBiometricEnabled;

  const UserSession({
    required this.userId,
    this.phone,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.isBiometricEnabled = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [
        userId,
        phone,
        accessToken,
        refreshToken,
        expiresAt,
        isBiometricEnabled,
      ];
}
