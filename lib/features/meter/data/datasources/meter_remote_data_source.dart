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
  Future<MeterModel> validateMeterBySerial(String serialNumber);
  Future<bool> pingMeter(String meterId);
}

class MeterRemoteDataSourceImpl implements MeterRemoteDataSource {
  final DioClient dioClient;

  MeterRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MeterModel>> getMeters() async {
    try {
      final response = await dioClient.dio.get('/meters/me');
      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        List<dynamic> list;
        if (raw is List) {
          list = raw;
        } else if (raw is Map && raw['data'] is List) {
          list = raw['data'] as List;
        } else if (raw is Map && raw['data'] is Map && raw['data']['meters'] is List) {
          list = raw['data']['meters'] as List;
        } else if (raw is Map && raw['meters'] is List) {
          list = raw['meters'] as List;
        } else {
          list = [];
        }
        return list.map((json) => MeterModel.fromJson(json as Map<String, dynamic>)).toList();
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
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : raw as Map<String, dynamic>;
        return MeterModel.fromJson(item);
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
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : raw as Map<String, dynamic>;
        return MeterModel.fromJson(item);
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
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : raw as Map<String, dynamic>;
        return MeterModel.fromJson(item);
      } else {
        throw ServerException('Failed to update meter');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeterModel> validateMeterBySerial(String serialNumber) async {
    try {
      // First try backend direct lookup endpoint
      try {
        final response = await dioClient.dio.get(
          '/meters/lookup',
          queryParameters: {'serial_number': serialNumber},
        );
        if (response.statusCode == 200) {
          final dynamic raw = response.data;
          final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
              ? raw['data'] as Map<String, dynamic>
              : raw as Map<String, dynamic>;
          return MeterModel.fromJson(item);
        }
      } catch (_) {
        // Fallback to /meters/{serialNumber}
        final response = await dioClient.dio.get('/meters/$serialNumber');
        if (response.statusCode == 200) {
          final dynamic raw = response.data;
          final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
              ? raw['data'] as Map<String, dynamic>
              : raw as Map<String, dynamic>;
          return MeterModel.fromJson(item);
        }
      }
      throw ServerException('Contador não encontrado');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Contador não encontrado no sistema EDM');
      }
      throw ServerException('Erro ao validar contador');
    }
  }

  @override
  Future<bool> pingMeter(String meterId) async {
    try {
      final response = await dioClient.dio.get('/meters/$meterId/status');
      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : raw as Map<String, dynamic>;
        
        return item['is_online'] == true;
      } else {
        return false;
      }
    } on DioException catch (_) {
      // If there's an error reaching the server or meter not found, assume offline for the fallback
      return false;
    }
  }
}
