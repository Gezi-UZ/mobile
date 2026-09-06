import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/recharge_breakdown_model.dart';
import '../models/recharge_model.dart';
import '../models/dashboard_stats_model.dart';

abstract class RechargeRemoteDataSource {
  Future<RechargeBreakdownModel> calculateBreakdown({
    required double amount,
    required String meterId,
  });

  Future<RechargeModel> initiateRecharge({
    required double amount,
    required String meterId,
  });

  Future<RechargeModel> applyCode({
    required String code,
    required String meterId,
  });

  Stream<RechargeModel> streamRechargeStatus(String rechargeId);

  Future<List<RechargeModel>> getRechargeHistory({
    required String meterId,
    int page = 1,
    int pageSize = 20,
  });

  Future<DashboardStatsModel> getDashboardStats({
    required String meterId,
    required String period,
  });
}

class RechargeRemoteDataSourceImpl implements RechargeRemoteDataSource {
  final DioClient dioClient;

  RechargeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RechargeBreakdownModel> calculateBreakdown({
    required double amount,
    required String meterId,
  }) async {
    // Simulando localmente até existir endpoint real
    return RechargeBreakdownModel(
      meterNumber: meterId,
      totalAmount: amount,
      valEnergia: amount * 0.7,
      iva: amount * 0.1,
      dividaPaga: 0,
      txRadio: amount * 0.05,
      txLixo: amount * 0.15,
      calculatedKwh: amount / 7.5,
      isFirstPurchaseOfMonth: true,
    );
  }

  @override
  Future<RechargeModel> initiateRecharge({
    required double amount,
    required String meterId,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/recharges/initiate',
        data: {
          'meter_id': meterId,
          'amount_mzn': amount,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return RechargeModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to initiate recharge');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<RechargeModel> applyCode({
    required String code,
    required String meterId,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/recharges/manual-code',
        data: {
          'meter_id': meterId,
          'recharge_code': code,
        },
      );
      if (response.statusCode == 200) {
        return RechargeModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to apply code');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Stream<RechargeModel> streamRechargeStatus(String rechargeId) async* {
    try {
      final response = await dioClient.dio.get(
        '/recharges/$rechargeId/stream',
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      final stream = response.data.stream as Stream<List<int>>;

      await for (final chunk in stream) {
        final lines = utf8.decode(chunk).split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6);
            if (jsonStr.trim().isEmpty) continue;

            final event = jsonDecode(jsonStr);
            if (event['event'] == 'stream_end') {
              return;
            }
            if (event['event'] == 'status_update') {
              yield RechargeModel.fromJson(event['data']);
            }
          }
        }
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error on stream');
    }
  }

  @override
  Future<List<RechargeModel>> getRechargeHistory({
    required String meterId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/recharges/history',
        queryParameters: {
          'meter_id': meterId,
          'page': page,
          'page_size': pageSize,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['recharges'];
        return data.map((json) => RechargeModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get recharge history');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<DashboardStatsModel> getDashboardStats({
    required String meterId,
    required String period,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/recharges/dashboard',
        queryParameters: {
          'meter_id': meterId,
          'period': period,
        },
      );
      if (response.statusCode == 200) {
        return DashboardStatsModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get dashboard stats');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
