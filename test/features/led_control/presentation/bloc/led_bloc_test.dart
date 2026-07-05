import 'package:gezi/core/errors/failures.dart';
import 'package:gezi/core/usecases/usecases.dart';
import 'package:gezi/features/led_control/domain/entities/led.dart';
import 'package:gezi/features/led_control/domain/repositories/led_repository.dart';
import 'package:gezi/features/led_control/domain/usecases/get_all_leds.dart';
import 'package:gezi/features/led_control/domain/usecases/toggle_led.dart';
import 'package:gezi/features/led_control/presentation/bloc/led_bloc.dart';
import 'package:gezi/features/led_control/presentation/bloc/led_event.dart';
import 'package:gezi/features/led_control/presentation/bloc/led_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

// Manual Mocks
class MockGetAllLeds implements GetAllLeds {
  @override
  LedRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, Map<String, bool>>> call(NoParams params) async {
    return const Right({'led_red': false});
  }
}

class MockToggleLed implements ToggleLed {
  @override
  LedRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, Led>> call(ToggleLedParams params) async {
    return Right(Led(id: params.ledId, state: params.state));
  }
}

class MockToggleLedFailure implements ToggleLed {
  @override
  LedRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, Led>> call(ToggleLedParams params) async {
    return const Left(ServerFailure('Server Error'));
  }
}

void main() {
  group('LedBloc Optimistic Update', () {
    late LedBloc bloc;
    late MockGetAllLeds mockGetAllLeds;
    late MockToggleLed mockToggleLed;

    setUp(() {
      mockGetAllLeds = MockGetAllLeds();
      mockToggleLed = MockToggleLed();
      bloc = LedBloc(getAllLeds: mockGetAllLeds, toggleLed: mockToggleLed);
    });

    test(
      'should emit [LedLoading, LedLoaded, LedLoaded(optimistic), LedLoaded(refresh)] when loading then toggling',
      () async {
        // 1. Load initial data
        bloc.add(LoadAllLedsEvent());

        // Wait for the initial load to complete
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<LedLoading>(),
            isA<LedLoaded>().having(
              (s) => s.leds['led_red'],
              'initial load',
              false,
            ),
          ]),
        );

        // 2. Trigger toggle
        bloc.add(ToggleLedEvent(ledId: 'led_red', state: true));

        // Expectation:
        // - No LedLoading!
        // - LedLoaded (optimistic: red=true)
        // - LedLoaded (refresh from mock: red=false)

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<LedLoaded>().having(
              (s) => s.leds['led_red'],
              'optimistic',
              true,
            ),
            isA<LedLoaded>().having((s) => s.leds['led_red'], 'refresh', false),
          ]),
        );
      },
    );

    test(
      'should emit [LedError, LedLoaded(previous)] when toggle fails',
      () async {
        bloc = LedBloc(
          getAllLeds: mockGetAllLeds,
          toggleLed: MockToggleLedFailure(),
        );

        // 1. Initial Load
        bloc.add(LoadAllLedsEvent());
        await expectLater(
          bloc.stream,
          emitsInOrder([isA<LedLoading>(), isA<LedLoaded>()]),
        );

        // 2. Trigger toggle fail
        bloc.add(ToggleLedEvent(ledId: 'led_red', state: true));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<LedLoaded>().having(
              (s) => s.leds['led_red'],
              'optimistic update',
              true,
            ),
            isA<LedError>(),
            isA<LedLoaded>().having((s) => s.leds['led_red'], 'revert', false),
          ]),
        );
      },
    );
  });
}
