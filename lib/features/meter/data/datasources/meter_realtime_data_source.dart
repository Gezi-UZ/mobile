import 'dart:async';
import '../../../../core/supabase/supabase_client.dart';
import '../models/meter_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class MeterRealtimeDataSource {
  Stream<MeterModel> watchMeterStatus(String meterId);
  Stream<List<MeterModel>> watchUserMeters(String userId);
}

class MeterRealtimeDataSourceImpl implements MeterRealtimeDataSource {
  @override
  Stream<MeterModel> watchMeterStatus(String meterId) {
    try {
      return supabase
          .from('contador')
          .stream(primaryKey: ['id'])
          .eq('id', meterId)
          .map((events) {
            if (events.isEmpty) {
              throw ServerException('Meter not found');
            }
            return MeterModel.fromJson(events.first);
          });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MeterModel>> watchUserMeters(String userId) {
    try {
      return supabase
          .from('contador')
          .stream(primaryKey: ['id'])
          .eq('utilizador_id', userId)
          .map((events) {
            return events.map((json) => MeterModel.fromJson(json)).toList();
          });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
