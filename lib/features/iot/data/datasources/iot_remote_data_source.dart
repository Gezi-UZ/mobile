import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/exceptions.dart';

abstract class IotRemoteDataSource {
  Future<void> sendCommand({
    required String meterId,
    required String commandType,
    Map<String, dynamic>? payload,
  });
}

class IotRemoteDataSourceImpl implements IotRemoteDataSource {
  final DioClient dioClient;

  IotRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> sendCommand({
    required String meterId,
    required String commandType,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final data = <String, dynamic>{
        'command_type': commandType,
      };
      if (payload != null) {
        data['payload'] = payload;
      }

      final response = await dioClient.dio.post(
        '/iot/meters/$meterId/command',
        data: data,
      );
      
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ServerException('Failed to send IoT command');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
