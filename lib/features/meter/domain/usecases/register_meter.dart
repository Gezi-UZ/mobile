import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class RegisterMeter implements UseCase<Meter, RegisterMeterParams> {
  final MeterRepository repository;

  RegisterMeter(this.repository);

  @override
  Future<Either<Failure, Meter>> call(RegisterMeterParams params) async {
    return await repository.addMeter(
      serialNumber: params.serialNumber,
      alias: params.alias,
      latitude: params.latitude,
      longitude: params.longitude,
      address: params.address,
    );
  }
}

class RegisterMeterParams extends Equatable {
  final String serialNumber;
  final String alias;
  final double latitude;
  final double longitude;
  final String address;

  const RegisterMeterParams({
    required this.serialNumber,
    required this.alias,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [serialNumber, alias, latitude, longitude, address];
}
