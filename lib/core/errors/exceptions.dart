/// Exception thrown when server returns error response
class ServerException implements Exception {
  final String message;
  
  ServerException([this.message = 'Server error']);
}

/// Exception thrown when network request fails
class NetworkException implements Exception {
  final String message;
  
  NetworkException([this.message = 'Network error']);
}

/// Exception thrown for local data/cache errors
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error']);
}