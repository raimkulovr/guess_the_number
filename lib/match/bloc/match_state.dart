part of 'match_bloc.dart';

class MatchState extends Equatable {
  const MatchState({
    required this.attemptsLeft,
    required this.generatedNumber,
    required this.matchWon,
    this.attempt = const Attempt.pure(maxValue: 0),
    this.checkedValues = const {},
    this.showHints = false,
    this.generateRandomNumbersOnAttempt = true,
  });

  final int attemptsLeft;
  final int generatedNumber;
  final bool? matchWon;
  final Attempt attempt;
  final Set<int> checkedValues;
  final bool showHints;
  final bool generateRandomNumbersOnAttempt;

  MatchState copyWith({
    int? attemptsLeft,
    int? generatedNumber,
    Attempt? attempt,
    Wrapped<bool?>? matchWon,
    Set<int>? checkedValues,
    bool? showHints,
    bool? generateRandomNumbersOnAttempt,
  }) {
    return MatchState(
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      generatedNumber: generatedNumber ?? this.generatedNumber,
      attempt: attempt ?? this.attempt,
      matchWon: matchWon != null ? matchWon.value : this.matchWon,
      checkedValues: checkedValues ?? this.checkedValues,
      showHints: showHints ?? this.showHints,
      generateRandomNumbersOnAttempt: generateRandomNumbersOnAttempt ?? this.generateRandomNumbersOnAttempt,
    );
  }

  @override
  String toString() {
    return 'MatchState{attemptsLeft: $attemptsLeft, generatedNumber: $generatedNumber, matchWon: $matchWon, attemptValue: $attempt, showHints: $showHints, checkedValues: ${checkedValues.length}, generateRandomNumbersOnAttempt: $generateRandomNumbersOnAttempt}';
  }

  @override
  List<Object?> get props => [
        attemptsLeft,
        generatedNumber,
        matchWon,
        attempt,
        checkedValues,
        showHints,
        generateRandomNumbersOnAttempt
      ];
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
