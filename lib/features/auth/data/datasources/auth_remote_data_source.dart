import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/session_model.dart';

// Keys used in Secure Storage
const _kPasswordKey = 'gezi_auth_password';
const _kRefreshTokenKey = 'gezi_auth_refresh_token';
const _kBiometricEnabledKey = 'gezi_biometric_enabled';
const _kPinHashKey = 'gezi_pin_hash';

abstract class AuthRemoteDataSource {
  /// Creates a new Supabase account via phone + auto-generated password.
  Future<SessionModel> signUp(String phone);

  /// Signs in with phone + password from secure storage.
  Future<SessionModel> signInWithPassword(String phone, String password);

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
  // Sign Up
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel> signUp(String phone) async {
    final password = _generateSecurePassword();
    final phoneE164 = _toE164(phone);

    final response = await supabase.auth.signUp(
      phone: phoneE164,
      password: password,
    );

    final session = response.session;
    if (session == null) {
      throw const AuthException('Sign-up failed: no session returned');
    }

    await secureStorage.write(key: _kPasswordKey, value: password);
    await secureStorage.write(
      key: _kRefreshTokenKey,
      value: session.refreshToken,
    );

    return SessionModel.fromSupabase(session);
  }

  // ─────────────────────────────────────────────────────────────────
  // Sign In with Password
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<SessionModel> signInWithPassword(
    String phone,
    String password,
  ) async {
    final phoneE164 = _toE164(phone);

    final response = await supabase.auth.signInWithPassword(
      phone: phoneE164,
      password: password,
    );

    final session = response.session;
    if (session == null) {
      throw const AuthException('Sign-in failed: no session returned');
    }

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
        data: {'biometric_enabled': true, 'biometric_setup_at': DateTime.now().toIso8601String()},
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
        data: {'pin_enabled': true, 'pin_setup_at': DateTime.now().toIso8601String()},
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

    // PIN is correct — restore Supabase session
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
      throw const AuthException('Nenhuma sessão encontrada para este dispositivo');
    }

    final response = await supabase.auth.setSession(refreshToken);
    final session = response.session;
    if (session == null) {
      throw const AuthException('Falha ao restaurar sessão no Supabase');
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
  // Helpers
  // ─────────────────────────────────────────────────────────────────

  String _hashPin(String pin) {
    final bytes = utf8.encode('gezi_salt_$pin');
    return sha256.convert(bytes).toString();
  }

  String _toE164(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('258')) return '+$digits';
    if (digits.length == 9) return '+258$digits';
    return '+$digits';
  }

  String _generateSecurePassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    final rng = Random.secure();
    return List.generate(32, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}