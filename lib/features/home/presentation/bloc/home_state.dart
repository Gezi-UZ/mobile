import 'package:equatable/equatable.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MeterBalance meterBalance;
  final int notificationCount;
  final List<Recharge> recentRecharges;

  const HomeLoaded({
    required this.meterBalance,
    required this.notificationCount,
    required this.recentRecharges,
  });

  @override
  List<Object?> get props => [meterBalance, notificationCount, recentRecharges];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
