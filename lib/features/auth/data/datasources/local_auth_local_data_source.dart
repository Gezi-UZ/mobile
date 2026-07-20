import 'package:local_auth/local_auth.dart';
import '../../../../core/errors/exceptions.dart';

abstract class LocalAuthLocalDataSource {
  Future<bool> checkBiometricsAvailable();
  Future<bool> authenticate({required String localizedReason});
}

class LocalAuthLocalDataSourceImpl implements LocalAuthLocalDataSource {
  final LocalAuthentication localAuth;

  LocalAuthLocalDataSourceImpl({required this.localAuth});

  @override
  Future<bool> checkBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await localAuth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
