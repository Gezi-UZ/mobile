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

  Future<RechargeModel> applyCode({required String code});

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
    // Cálculo 100% local em Dart para visualização imediata no frontend,
    // alinhado com a fórmula oficial CREDELEC do backend.
    bool isFirstPurchase = false;

    try {
      final history = await getRechargeHistory(
        meterId: meterId,
        page: 1,
        pageSize: 20,
      );
      final now = DateTime.now();
      final hasPurchaseThisMonth = history.any(
        (r) =>
            r.createdAt.month == now.month &&
            r.createdAt.year == now.year &&
            (const {
              'success',
              'concluída',
              'concluida',
              'ack_received',
              'confirmed',
              'mqtt_sent',
              'confirmed_no_device',
              'completed',
            }.contains(r.status.toLowerCase())),
      );
      if (!hasPurchaseThisMonth && history.isNotEmpty) {
        isFirstPurchase = true;
      }
    } catch (_) {
      // Por omissão assume false se não houver histórico carregado
    }

    const double ratePerKwh = 7.64;
    const double taxaIva = 0.16;
    const double taxaRadio = 15.00;
    const double taxaLixo = 100.00;

    final double maxDeducao = amount * 0.5;
    double totalDeduzido = 0.0;
    double txRadio = 0.0;
    double txLixo = 0.0;

    if (isFirstPurchase) {
      final double pagoRadio = (taxaRadio < (maxDeducao - totalDeduzido))
          ? taxaRadio
          : (maxDeducao - totalDeduzido);
      txRadio = (pagoRadio > 0) ? pagoRadio : 0.0;
      totalDeduzido += txRadio;

      final double pagoLixo = (taxaLixo < (maxDeducao - totalDeduzido))
          ? taxaLixo
          : (maxDeducao - totalDeduzido);
      txLixo = (pagoLixo > 0) ? pagoLixo : 0.0;
      totalDeduzido += txLixo;
    }

    final double restante = amount - totalDeduzido;
    final double valEnergia = restante / (1.0 + taxaIva);
    final double iva = restante - valEnergia;
    final double kwh = valEnergia / ratePerKwh;

    return RechargeBreakdownModel(
      meterNumber: meterId,
      totalAmount: double.parse(amount.toStringAsFixed(2)),
      valEnergia: double.parse(valEnergia.toStringAsFixed(2)),
      iva: double.parse(iva.toStringAsFixed(2)),
      dividaPaga: 0.0,
      txRadio: double.parse(txRadio.toStringAsFixed(2)),
      txLixo: double.parse(txLixo.toStringAsFixed(2)),
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
      final data = {'meter_id': meterId, 'amount_mzn': amount};
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
  Future<RechargeModel> applyCode({required String code}) async {
    try {
      final response = await dioClient.dio.post(
        '/recharges/manual-code',
        data: {'recharge_code': code},
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
      String errorMessage = 'Network error';
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final data = e.response?.data as Map<String, dynamic>;
        if (data.containsKey('detail')) {
          errorMessage = data['detail'].toString();
        } else if (data.containsKey('message')) {
          errorMessage = data['message'].toString();
        } else {
          errorMessage = e.message ?? 'Unknown error';
        }
      } else {
        errorMessage = e.message ?? 'Network error';
      }
      throw ServerException(errorMessage);
    }
  }

  @override
  Stream<RechargeModel> streamRechargeStatus(String rechargeId) async* {
    String lastStatus = 'PENDING';
    RechargeModel? lastModel;

    try {
      final response = await dioClient.dio.get(
        '/recharges/$rechargeId/stream',
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream', 'Cache-Control': 'no-cache'},
        ),
      );

      final stream = response.data.stream as Stream<List<int>>;

      await for (final line
          in stream.transform(utf8.decoder).transform(const LineSplitter())) {
        if (line.startsWith('data: ')) {
          final jsonStr = line.substring(6);
          if (jsonStr.trim().isEmpty) continue;

          final event = jsonDecode(jsonStr);
          if (event['event'] == 'stream_end') {
            if (const {
              'CONCLUIDA',
              'SUCCESS',
              'ACK_RECEIVED',
              'CONFIRMED_NO_DEVICE',
              'FAILED',
              'REFUNDED',
              'EXPIRED',
            }.contains(lastStatus)) {
              return;
            }
            break;
          }

          if (event['event'] == 'status_update' && event['data'] != null) {
            final model =
                RechargeModel.fromJson(event['data'] as Map<String, dynamic>);
            lastStatus = model.status.toUpperCase();
            lastModel = model;
            yield model;

            if (const {
              'CONCLUIDA',
              'SUCCESS',
              'ACK_RECEIVED',
              'CONFIRMED_NO_DEVICE',
              'FAILED',
              'REFUNDED',
              'EXPIRED',
            }.contains(lastStatus)) {
              return;
            }
          }
        }
      }
    } catch (_) {
      // SSE desconectou, falhou ou deu timeout. Passamos para o polling de fallback.
    }

    // ─────────────────────────────────────────────────────────────────
    // FALLBACK: POLLING REGULAR
    // Se a stream SSE caiu ou encerrou antes de atingir um estado terminal,
    // fazemos polling a /status a cada 2.5s durante até 60 segundos.
    // ─────────────────────────────────────────────────────────────────
    final startTime = DateTime.now();
    const pollInterval = Duration(milliseconds: 2500);
    const maxDuration = Duration(seconds: 60);

    while (DateTime.now().difference(startTime) < maxDuration) {
      try {
        final statusResponse = await dioClient.dio.get(
          '/recharges/$rechargeId/status',
        );

        if (statusResponse.statusCode == 200) {
          final dynamic raw = statusResponse.data;
          final Map<String, dynamic> data = (raw is Map && raw['data'] is Map)
              ? raw['data'] as Map<String, dynamic>
              : (raw is Map ? raw as Map<String, dynamic> : {});

          if (data.isNotEmpty) {
            final model = RechargeModel.fromJson(data);
            lastStatus = model.status.toUpperCase();
            lastModel = model;
            yield model;

            if (const {
              'CONCLUIDA',
              'SUCCESS',
              'ACK_RECEIVED',
              'CONFIRMED_NO_DEVICE',
              'FAILED',
              'REFUNDED',
              'EXPIRED',
            }.contains(lastStatus)) {
              return;
            }
          }
        }
      } catch (_) {
        // Ignora erros individuais de HTTP no polling e tenta no ciclo seguinte
      }

      await Future.delayed(pollInterval);
    }

    // Se após 60s de polling ainda não tivemos resposta terminal:
    // Se tính tínhamos chegado a CONFIRMED ou MQTT_SENT, entregamos esse modelo final.
    if (lastModel != null &&
        const {
          'CONFIRMED',
          'MQTT_SENT',
          'CONCLUIDA',
          'SUCCESS',
          'ACK_RECEIVED',
          'CONFIRMED_NO_DEVICE',
        }.contains(lastStatus)) {
      yield lastModel;
      return;
    }

    throw ServerException('Tempo limite excedido a aguardar confirmação do pagamento');
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
        } else if (raw is Map &&
            raw['data'] is Map &&
            raw['data']['recharges'] is List) {
          list = raw['data']['recharges'] as List;
        } else if (raw is Map && raw['recharges'] is List) {
          list = raw['recharges'] as List;
        } else {
          list = [];
        }
        return list
            .map((json) => RechargeModel.fromJson(json as Map<String, dynamic>))
            .toList();
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
        queryParameters: {'meter_id': meterId, 'period': period},
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
