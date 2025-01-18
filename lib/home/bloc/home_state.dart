part of 'home_bloc.dart';

final class HomeState {
  const HomeState({
    this.rangeEnd = const RangeEnd.pure(),
    this.attempts = const Attempts.pure(),
    this.canStartGame = true,
  });

  final RangeEnd rangeEnd;
  final Attempts attempts;
  final bool canStartGame;

  HomeState copyWith({
    RangeEnd? rangeEnd,
    Attempts? attempts,
    bool? canStartGame,
  }) {
    return HomeState(
      rangeEnd: rangeEnd ?? this.rangeEnd,
      attempts: attempts ?? this.attempts,
      canStartGame: canStartGame ?? this.canStartGame,
    );
  }

  @override
  String toString() {
    return 'HomeState{rangeEnd: $rangeEnd, attempts: $attempts, canStartGame: $canStartGame}';
  }
}
