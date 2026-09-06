import 'package:dio/dio.dart';
import '../models/meter_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/exceptions.dart';

abstract class MeterRemoteDataSource {
  Future<List<MeterModel>> getMeters();
  Future<MeterModel> addMeter({
    required String serialNumber,
    required String alias,
    required double latitude,
    required double longitude,
    required String address,
  });
  Future<MeterModel> getMeterDetails(String meterId);
  Future<MeterModel> updateMeter(String meterId, {String? alias, bool? isPrimary});
}

class MeterRemoteDataSourceImpl implements MeterRemoteDataSource {
  final DioClient dioClient;

  MeterRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MeterModel>> getMeters() async {
    try {
      final response = await dioClient.dio.get('/meters/me');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MeterModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load meters');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeterModel> addMeter({
    required String serialNumber,
    required String alias,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/meters/',
        data: {
          'serial_number': serialNumber,
          'label': alias,
          'location': {
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
          }
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return MeterModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to add meter');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeterModel> getMeterDetails(String meterId) async {
    try {
      final response = await dioClient.dio.get('/meters/$meterId');
      if (response.statusCode == 200) {
        return MeterModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to get meter details');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeterModel> updateMeter(String meterId, {String? alias, bool? isPrimary}) async {
    try {
      final data = <String, dynamic>{};
      if (alias != null) data['label'] = alias;
      if (isPrimary != null) data['is_primary'] = isPrimary;

      final response = await dioClient.dio.patch(
        '/meters/$meterId',
        data: data,
      );
      if (response.statusCode == 200) {
        return MeterModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update meter');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
