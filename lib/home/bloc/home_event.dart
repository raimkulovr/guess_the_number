part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeNewRangeEndSet extends HomeEvent {
  final int rangeEnd;

  const HomeNewRangeEndSet({
    required this.rangeEnd,
  });

  @override
  List<Object> get props => [rangeEnd];
}

class HomeNewAttemptsSet extends HomeEvent {
  final int attempts;

  const HomeNewAttemptsSet({
    required this.attempts,
  });

  @override
  List<Object> get props => [attempts];
}
