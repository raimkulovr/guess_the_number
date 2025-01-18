import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:guess_the_number/game_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'history_state.dart';

class HistoryCubit extends HydratedCubit<HistoryState> {
  HistoryCubit({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const HistoryState(results: []))
  {
    _historyStreamSubscription = _gameRepository.historyStream.listen((event) {
      emit(state.copyWith(results: event));
    });
  }

  late final StreamSubscription _historyStreamSubscription;
  final GameRepository _gameRepository;

  void resetHistory() {
    emit(state.copyWith(results: []));
    _gameRepository.history = [];
  }

  @override
  Map<String, dynamic> toJson(HistoryState state) => state.toJson();

  @override
  HistoryState fromJson(Map<String, dynamic> json) {
    final state = HistoryState.fromJson(json);
    _gameRepository.history = state.results;
    return state;
  }

  @override
  Future<void> close() {
    _historyStreamSubscription.cancel();
    return super.close();
  }
}
