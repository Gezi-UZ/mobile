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
    String? phone,
  });

  Future<RechargeModel> applyCode({
    required String code,
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
    try {
      final response = await dioClient.dio.get(
        '/recharges/calculate',
        queryParameters: {
          'meter_id': meterId,
          'amount_mzn': amount,
        },
      );
      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final Map<String, dynamic> data = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : (raw is Map ? raw as Map<String, dynamic> : {});
        return RechargeBreakdownModel.fromJson(data);
      }
    } catch (_) {
      // Fallback para fórmula tarifária oficial EDM (CREDELEC Doméstica)
    }

    const double ratePerKwh = 7.64; // Tarifa Doméstica padrão EDM
    bool isFirstPurchase = amount >= 100.0;

    try {
      final history = await getRechargeHistory(meterId: meterId, page: 1, pageSize: 20);
      final now = DateTime.now();
      final hasPurchaseThisMonth = history.any((r) => 
        r.createdAt.month == now.month && 
        r.createdAt.year == now.year &&
        (r.status.toLowerCase() == 'success' || r.status.toLowerCase() == 'concluída')
      );
      if (hasPurchaseThisMonth) {
        isFirstPurchase = false;
      }
    } catch (_) {
      // Ignorar se a busca de histórico falhar
    }

    double lixoFee = 0.0;
    if (isFirstPurchase) {
      if (amount == 100.0) {
        lixoFee = 50.0;
      } else if (amount > 100.0) {
        lixoFee = 100.0;
      }
    }
    final double netForEnergy = (amount > lixoFee) ? (amount - lixoFee) : amount;
    final double kwh = netForEnergy / ratePerKwh;

    return RechargeBreakdownModel(
      meterNumber: meterId,
      totalAmount: amount,
      valEnergia: netForEnergy,
      iva: amount * 0.16,
      dividaPaga: 0.0,
      txRadio: 0.0,
      txLixo: lixoFee,
      calculatedKwh: double.parse(kwh.toStringAsFixed(2)),
      isFirstPurchaseOfMonth: isFirstPurchase,
    );
  }

  @override
  Future<RechargeModel> initiateRecharge({
    required double amount,
    required String meterId,
    String? phone,
  }) async {
    try {
      final data = {
        'meter_id': meterId,
        'amount_mzn': amount,
      };
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }
      
      final response = await dioClient.dio.post(
        '/recharges/initiate',
        data: data,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : (raw is Map ? raw as Map<String, dynamic> : {});
        return RechargeModel.fromJson(item);
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
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/recharges/manual-code',
        data: {
          'recharge_code': code,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : (raw is Map ? raw as Map<String, dynamic> : {});
        return RechargeModel.fromJson(item);
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
        final dynamic raw = response.data;
        List<dynamic> list;
        if (raw is List) {
          list = raw;
        } else if (raw is Map && raw['data'] is List) {
          list = raw['data'] as List;
        } else if (raw is Map && raw['data'] is Map && raw['data']['recharges'] is List) {
          list = raw['data']['recharges'] as List;
        } else if (raw is Map && raw['recharges'] is List) {
          list = raw['recharges'] as List;
        } else {
          list = [];
        }
        return list.map((json) => RechargeModel.fromJson(json as Map<String, dynamic>)).toList();
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
        final dynamic raw = response.data;
        final Map<String, dynamic> item = (raw is Map && raw['data'] is Map)
            ? raw['data'] as Map<String, dynamic>
            : (raw is Map ? raw as Map<String, dynamic> : {});
        return DashboardStatsModel.fromJson(item);
      } else {
        throw ServerException('Failed to get dashboard stats');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
