part of 'match_bloc.dart';

sealed class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class _MatchWon extends MatchEvent {}

class _MatchLost extends MatchEvent {}

class MatchGiveUp extends MatchEvent {}

class MatchShowHints extends MatchEvent {}

class MatchGenerateNumbersOnAttempt extends MatchEvent {}

class MatchRestarted extends MatchEvent {}

class MatchAttemptUsed extends MatchEvent {}

class MatchNewAttemptValueSet extends MatchEvent {
  final int? attemptValue;

  const MatchNewAttemptValueSet({
    this.attemptValue,
  });

  @override
  List<Object?> get props => [attemptValue];
}
