import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/iot_repository.dart';

class SendIotCommand implements UseCase<void, SendIotCommandParams> {
  final IotRepository repository;

  SendIotCommand(this.repository);

  @override
  Future<Either<Failure, void>> call(SendIotCommandParams params) async {
    return await repository.sendCommand(
      meterId: params.meterId,
      commandType: params.commandType,
      payload: params.payload,
    );
  }
}

class SendIotCommandParams extends Equatable {
  final String meterId;
  final String commandType;
  final Map<String, dynamic>? payload;

  const SendIotCommandParams({
    required this.meterId,
    required this.commandType,
    this.payload,
  });

  @override
  List<Object?> get props => [meterId, commandType, payload];
}
