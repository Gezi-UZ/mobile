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