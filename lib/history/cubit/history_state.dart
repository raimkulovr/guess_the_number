part of 'history_cubit.dart';

final class HistoryState extends Equatable {
  const HistoryState({
    required this.results,
  });

  final List<GameResult> results;

  HistoryState copyWith({
    List<GameResult>? results,
  }) {
    return HistoryState(
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
    };
  }

  factory HistoryState.fromJson(Map<String, dynamic> json) {
    return HistoryState(
      results: (json['results'] as List<dynamic>).map((e) => GameResult.fromJson(e),).toList(),
    );
  }

  @override
  List<Object> get props => [results];

  @override
  String toString() {
    return 'HistoryState{results: ${results.length}}';
  }

}
