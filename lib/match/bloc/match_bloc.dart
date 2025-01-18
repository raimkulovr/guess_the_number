import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:guess_the_number/match/models/attempt.dart';
import 'package:guess_the_number/game_repository.dart';

part 'match_event.dart';
part 'match_state.dart';

final math.Random _random = math.Random();
int _generateRandomInt(int maxValue) {
  return _random.nextInt(maxValue - 1) + 1;
}

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        rangeEnd = gameRepository.rangeEnd,
        maxAttempts = gameRepository.attempts,
        super(MatchState(
          attemptsLeft: gameRepository.attempts,
          generatedNumber: _generateRandomInt(gameRepository.rangeEnd),
          matchWon: null,
          attempt: Attempt.dirty(
              value: _generateRandomInt(gameRepository.rangeEnd),
              maxValue: gameRepository.rangeEnd,
              isCheckedValue: false),
  )) {
    on<_MatchWon>(_onMatchWon);
    on<_MatchLost>(_onMatchLost);
    on<MatchGiveUp>(_onMatchGiveUp);
    on<MatchShowHints>(_onMatchShowHints);
    on<MatchGenerateNumbersOnAttempt>(_onMatchGenerateNumbersOnAttempt);
    on<MatchRestarted>(_onMatchRestarted);
    on<MatchAttemptUsed>(_onMatchAttemptUsed);
    on<MatchNewAttemptValueSet>(_onMatchNewAttemptValueSet);
  }

  final int rangeEnd;
  final int maxAttempts;
  final GameRepository _gameRepository;

  void _recordMatchResult({required bool didWin}) {
    _gameRepository.addGameResult(GameResult(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      rangeEnd: rangeEnd,
      allowedAttempts: maxAttempts,
      usedAttempts: maxAttempts - state.attemptsLeft,
      didWin: didWin,
      withHints: state.showHints,
    ));
  }

  int _generateRandomAttemptValue() {
    while (true) {
      final newInt = _generateRandomInt(rangeEnd);
      if (!state.checkedValues.contains(newInt)) return newInt;
    }
  }

  void _onMatchWon(
    _MatchWon event,
    Emitter<MatchState> emit,
  ) {
    _recordMatchResult(didWin: true);

    emit(
      state.copyWith(
        matchWon: Wrapped.value(true),
      ),
    );
  }

  void _onMatchLost(
    _MatchLost event,
    Emitter<MatchState> emit,
  ) {
    _recordMatchResult(didWin: false);

    emit(
      state.copyWith(
        matchWon: Wrapped.value(false),
      ),
    );
  }

  void _onMatchGiveUp(
    MatchGiveUp event,
    Emitter<MatchState> emit,
  ) {
    if(state.attemptsLeft!=maxAttempts)
      _recordMatchResult(didWin: false);
  }

  void _onMatchShowHints(
    MatchShowHints event,
    Emitter<MatchState> emit,
  ) {
    emit(state.copyWith(showHints: !state.showHints));
  }

  void _onMatchGenerateNumbersOnAttempt(
    MatchGenerateNumbersOnAttempt event,
    Emitter<MatchState> emit,
  ) {
    final newValue = !state.generateRandomNumbersOnAttempt;
    if(newValue){
      add(MatchNewAttemptValueSet(attemptValue: _generateRandomAttemptValue()));
    }
    emit(state.copyWith(generateRandomNumbersOnAttempt: newValue));
  }

  void _onMatchNewAttemptValueSet(
    MatchNewAttemptValueSet event,
    Emitter<MatchState> emit,
  ) {
    final value = event.attemptValue ?? state.attempt.value;
    final attemptValue = Attempt.dirty(
        value: value,
        maxValue: rangeEnd,
        isCheckedValue: state.checkedValues.contains(value));

    emit(
      state.copyWith(
        attempt: attemptValue,
      ),
    );
  }

  void _onMatchAttemptUsed(
    MatchAttemptUsed event,
    Emitter<MatchState> emit,
  ) {
    final currentValue = state.attempt.value;

    if (state.checkedValues.contains(currentValue)) {
      add(MatchNewAttemptValueSet());
    } else {
      emit(state.copyWith(
        attemptsLeft: state.attemptsLeft - 1,
        checkedValues: {...state.checkedValues, currentValue},
      ));

      if (currentValue == state.generatedNumber) {
        add(_MatchWon());
      } else if (state.attemptsLeft == 0) {
        add(_MatchLost());
      } else {
        add(MatchNewAttemptValueSet(
            attemptValue: state.generateRandomNumbersOnAttempt ? _generateRandomAttemptValue() : null));
      }

    }
  }

  void _onMatchRestarted(
    MatchRestarted event,
    Emitter<MatchState> emit,
  ) {
    emit(state.copyWith(
      attemptsLeft: maxAttempts,
      matchWon: Wrapped.value(null),
      generatedNumber: _generateRandomInt(rangeEnd),
      checkedValues: {},
      showHints: false,
    ));

    add(MatchNewAttemptValueSet(attemptValue: _generateRandomAttemptValue()));
  }
}
