import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/led_model.dart';

/// Contract for LED remote data source
abstract class LedRemoteDataSource {
  Future<Map<String, bool>> getAllLeds();
  Future<LedModel> getLed(String ledId);
  Future<LedModel> setLed(String ledId, bool state);
}

/// Implementation of LED remote data source using Dio
class LedRemoteDataSourceImpl implements LedRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  LedRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<Map<String, bool>> getAllLeds() async {
    try {
      final response = await dio.get('$baseUrl/led');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          // Convert Map<String, dynamic> to Map<String, bool>
          final ledData = data['data'] as Map<String, dynamic>;
          return ledData.map((key, value) => MapEntry(key, value as bool));
        } else {
          throw ServerException(data['error'] ?? 'Unknown error');
        }
      } else {
        throw ServerException('Failed to get LEDs: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<LedModel> getLed(String ledId) async {
    try {
      final response = await dio.get('$baseUrl/led/$ledId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return LedModel.fromJson(data['data']);
        } else {
          throw ServerException(data['error'] ?? 'Unknown error');
        }
      } else {
        throw ServerException('Failed to get LED: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<LedModel> setLed(String ledId, bool state) async {
    try {
      final response = await dio.post(
        '$baseUrl/led',
        data: {
          'id': ledId,
          'state': state,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return LedModel.fromJson(data['data']);
        } else {
          throw ServerException(data['error'] ?? 'Unknown error');
        }
      } else {
        throw ServerException('Failed to set LED: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}