import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeDashboardLoadRequested extends HomeEvent {
  final bool isRefresh;
  const HomeDashboardLoadRequested({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}