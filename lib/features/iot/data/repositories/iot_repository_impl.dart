import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/iot_repository.dart';
import '../datasources/iot_remote_data_source.dart';

class IotRepositoryImpl implements IotRepository {
  final IotRemoteDataSource remoteDataSource;

  IotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> sendCommand({
    required String meterId,
    required String commandType,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await remoteDataSource.sendCommand(
        meterId: meterId,
        commandType: commandType,
        payload: payload,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
