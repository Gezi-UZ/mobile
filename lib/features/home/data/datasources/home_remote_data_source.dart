import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/recharge_model.dart';
import '../../domain/entities/meter_balance.dart';
import '../../domain/entities/recharge.dart';

import '../../../meter/data/models/meter_model.dart';

abstract class HomeRemoteDataSource {
  /// Obtém o saldo do contador a partir do servidor remoto.
  Future<MeterBalance> getMeterBalance();

  /// Obtém as últimas [limit] recargas do utilizador.
  Future<List<Recharge>> getRecentRecharges({int limit = 5});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {

  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MeterBalance> getMeterBalance() async {
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
        if (list.isEmpty) {
          return MeterBalance(
            kwhBalance: 0.0,
            meterId: 'Sem contador',
            isOnline: false,
            lastSyncAt: DateTime.now(),
            isLowBalance: true,
          );
        }

        final meters = list
            .map((json) => MeterModel.fromJson(json as Map<String, dynamic>))
            .toList();
        final primary = meters.firstWhere(
          (m) => m.isPrimary,
          orElse: () => meters.first,
        );

        return MeterBalance(
          kwhBalance: primary.kwhBalance,
          meterId: primary.serialNumber,
          isOnline: primary.isOnline,
          lastSyncAt: primary.lastSyncAt ?? DateTime.now(),
          isLowBalance: primary.kwhBalance < 5.0,
        );
      }
      throw ServerException('Erro ao carregar saldo do contador');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de rede ao carregar saldo');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Recharge>> getRecentRecharges({int limit = 5}) async {
    try {
      final response = await dioClient.dio.get(
        '/recharges/history',
        queryParameters: {'page': 1, 'page_size': limit},
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
        return list
            .map((json) => RechargeModel.fromJson(json as Map<String, dynamic>))
            .take(limit)
            .toList();
      }
      return [];
    } catch (_) {
      // Retorna lista vazia em caso de falha suave
      return [];
    }
  }
}
