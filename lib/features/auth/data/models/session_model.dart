import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/session.dart';

/// Maps a Supabase [sb.Session] to the domain [UserSession] entity.
class SessionModel extends UserSession {
  const SessionModel({
    required super.userId,
    super.phone,
    super.email,
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    super.isBiometricEnabled,
  });

  factory SessionModel.fromSupabase(
    sb.Session session, {
    bool isBiometricEnabled = false,
  }) {
    final user = session.user;
    return SessionModel(
      userId: user.id,
      phone: user.phone,
      email: user.email,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      ),
      isBiometricEnabled: isBiometricEnabled,
    );
  }
}
