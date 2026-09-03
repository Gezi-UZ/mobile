import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/session_model.dart';

// Keys used in Secure Storage
const _kRefreshTokenKey = 'gezi_auth_refresh_token';
const _kBiometricEnabledKey = 'gezi_biometric_enabled';
const _kPinHashKey = 'gezi_pin_hash';

abstract class AuthRemoteDataSource {
  /// Creates a new user with [email] and [pin], storing [fullName] in user metadata.
  Future<SessionModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String pin,
  });

  /// Authenticates an existing user using [email] and [pin].
  Future<SessionModel> signInWithEmail({
    required String email,
    required String pin,
  });

  /// Returns the current active session, or null.
  Future<SessionModel?> getCurrentSession();

  /// Signs out from Supabase and clears local tokens.
  Future<void> signOut();

  /// Stores refresh token in secure storage and marks biometric as enabled.
  Future<void> enableBiometric(SessionModel session);

  /// Saves a 6-digit PIN (hashed via SHA-256) in hardware secure storage.
  Future<void> savePin(String pin, SessionModel session);

  /// Verifies a 6-digit PIN against the stored hash, and restores Supabase session if correct.
  Future<SessionModel> verifyPin(String pin);

  /// Restores a Supabase session using the stored refresh token.
  Future<SessionModel> restoreSessionFromSecureStorage();

  /// Returns true if biometric was previously enabled on this device.
  Future<bool> isBiometricEnabled();

  /// Returns true if a PIN was previously configured on this device.
  Future<bool> isPinConfigured();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSourceImpl({required this.secureStorage});

  // ─────────────────────────────────────────────────────────────────
  // Email & PIN — Sign Up
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String pin,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: pin,
      data: {'full_name': fullName},
    );

    final session = response.session;
    if (session == null) {
      throw const AuthException('Registo falhou: Nenhuma sessão retornada. Verifique se a confirmação de e-mail está ligada no Supabase.');
    }

    // Persist the refresh token for biometric / PIN restore
    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );

    final biometricEnabled = await isBiometricEnabled();
    return SessionModel.fromSupabase(session, isBiometricEnabled: biometricEnabled);
  }

  // ─────────────────────────────────────────────────────────────────
  // Email & PIN — Sign In
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel> signInWithEmail({
    required String email,
    required String pin,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: pin,
    );

    final session = response.session;
    if (session == null) {
      throw const AuthException('Login falhou: Nenhuma sessão retornada.');
    }

    // Persist the refresh token for biometric / PIN restore
    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );

    final biometricEnabled = await isBiometricEnabled();
    return SessionModel.fromSupabase(session, isBiometricEnabled: biometricEnabled);
  }

  // ─────────────────────────────────────────────────────────────────
  // Get Current Session
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel?> getCurrentSession() async {
    final session = supabase.auth.currentSession;
    if (session == null) return null;

    final biometricEnabled = await isBiometricEnabled();
    return SessionModel.fromSupabase(session, isBiometricEnabled: biometricEnabled);
  }

  // ─────────────────────────────────────────────────────────────────
  // Sign Out
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
    await secureStorage.delete(key: _kRefreshTokenKey);
  }

  // ─────────────────────────────────────────────────────────────────
  // Biometric — Enable
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<void> enableBiometric(SessionModel session) async {
    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );
    await secureStorage.write(key: _kBiometricEnabledKey, value: 'true');

    await supabase.auth.updateUser(
      UserAttributes(
        data: {
          'biometric_enabled': true,
          'biometric_setup_at': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // PIN — Save & Verify
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<void> savePin(String pin, SessionModel session) async {
    final hash = _hashPin(pin);
    await secureStorage.write(key: _kPinHashKey, value: hash);
    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );

    await supabase.auth.updateUser(
      UserAttributes(
        data: {
          'pin_enabled': true,
          'pin_setup_at': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  @override
  Future<SessionModel> verifyPin(String pin) async {
    final storedHash = await secureStorage.read(key: _kPinHashKey);
    if (storedHash == null) {
      throw const AuthException('Nenhum PIN configurado neste dispositivo.');
    }

    final inputHash = _hashPin(pin);
    if (inputHash != storedHash) {
      throw const AuthException('PIN incorreto. Tente novamente.');
    }

    return restoreSessionFromSecureStorage();
  }

  @override
  Future<bool> isPinConfigured() async {
    final hash = await secureStorage.read(key: _kPinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  // ─────────────────────────────────────────────────────────────────
  // Restore Session
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel> restoreSessionFromSecureStorage() async {
    final refreshToken = await secureStorage.read(key: _kRefreshTokenKey);
    if (refreshToken == null) {
      throw const AuthException('Nenhuma sessao encontrada para este dispositivo.');
    }

    final response = await supabase.auth.setSession(refreshToken);
    final session = response.session;
    if (session == null) {
      throw const AuthException('Falha ao restaurar sessao no Supabase.');
    }

    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );

    return SessionModel.fromSupabase(session, isBiometricEnabled: true);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await secureStorage.read(key: _kBiometricEnabledKey);
    return value == 'true';
  }

  // ─────────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────────

  String _hashPin(String pin) {
    final bytes = utf8.encode('gezi_salt_$pin');
    return sha256.convert(bytes).toString();
  }

  // ignore: unused_element
  String _toE164(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('258')) return '+$digits';
    if (digits.length == 9) return '+258$digits';
    return '+$digits';
  }

  // ignore: unused_element
  String _generateSecurePassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    final rng = Random.secure();
    return List.generate(32, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
