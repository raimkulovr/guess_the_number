import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:guess_the_number/game_repository.dart';

import '../models/models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(HomeState()) {
    on<HomeNewAttemptsSet>(_onHomeNewAttemptsSet);
    on<HomeNewRangeEndSet>(_onHomeNewRangeEndSet);
  }

  final GameRepository _gameRepository;

  void _onHomeNewRangeEndSet(
    HomeNewRangeEndSet event,
    Emitter<HomeState> emit,
  ) {
    final rangeEnd = RangeEnd.dirty(event.rangeEnd);
    final attempts = state.attempts.value > rangeEnd.value
        ? Attempts.dirty(rangeEnd.value)
        : null;

    emit(
      state.copyWith(
        rangeEnd: rangeEnd,
        attempts: attempts,
        canStartGame: Formz.validate([attempts ?? state.attempts, rangeEnd]),
      ),
    );

    _gameRepository.rangeEnd = rangeEnd.value;
  }

  void _onHomeNewAttemptsSet(
    HomeNewAttemptsSet event,
    Emitter<HomeState> emit,
  ) {
    late final Attempts attempts;
    if (state.rangeEnd.isValid) {
      final maxValue = state.rangeEnd.value;
      attempts =
          Attempts.dirty(event.attempts > maxValue ? maxValue : event.attempts);
    } else {
      attempts = Attempts.dirty(event.attempts);
    }

    emit(
      state.copyWith(
        attempts: attempts,
        canStartGame: Formz.validate([attempts, state.rangeEnd]),
      ),
    );

    _gameRepository.attempts = attempts.value;
  }
}
