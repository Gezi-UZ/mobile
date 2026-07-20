abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String code);
  Future<void> createPasskey(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> requestOtp(String phoneNumber) async {
    // Mock Supabase call
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String code) async {
    // Mock Supabase call
    await Future.delayed(const Duration(seconds: 1));
    return code == '123456'; // Mock successful code
  }

  @override
  Future<void> createPasskey(String phoneNumber) async {
    // Mock Supabase call / local_auth setup
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}