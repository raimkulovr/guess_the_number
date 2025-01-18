import 'package:rxdart/rxdart.dart';

final class GameResult {
  const GameResult({
    required this.rangeEnd,
    required this.allowedAttempts,
    required this.usedAttempts,
    required this.didWin,
    required this.timestamp,
    required this.withHints,
  });

  final int rangeEnd;
  final int allowedAttempts;
  final int usedAttempts;
  final bool didWin;
  final int timestamp;
  final bool withHints;

  Map<String, dynamic> toJson() {
    return {
      'rangeEnd': rangeEnd,
      'allowedAttempts': allowedAttempts,
      'usedAttempts': usedAttempts,
      'didWin': didWin,
      'timestamp': timestamp,
      'withHints': withHints,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      rangeEnd: json['rangeEnd'] as int,
      allowedAttempts: json['allowedAttempts'] as int,
      usedAttempts: json['usedAttempts'] as int,
      didWin: json['didWin'] as bool,
      timestamp: json['timestamp'] as int,
      withHints: json['withHints'] as bool,
    );
  }
}

final class GameRepository {
  GameRepository() {
    _rangeEndBehaviorSubject.add(10);
    _attemptsBehaviorSubject.add(5);
    _historyBehaviorSubject.add([]);
  }
  final _rangeEndBehaviorSubject = BehaviorSubject<int>();
  final _attemptsBehaviorSubject = BehaviorSubject<int>();
  final _historyBehaviorSubject = BehaviorSubject<List<GameResult>>();

  int get rangeEnd => _rangeEndBehaviorSubject.value;
  int get attempts => _attemptsBehaviorSubject.value;
  List<GameResult> get history => _historyBehaviorSubject.value;

  Stream<int> get rangeEndStream => _rangeEndBehaviorSubject.stream;
  Stream<int> get attemptsStream => _attemptsBehaviorSubject.stream;
  Stream<List<GameResult>> get historyStream => _historyBehaviorSubject.stream;

  set rangeEnd(int newValue) => _rangeEndBehaviorSubject.add(newValue);
  set attempts(int newValue) => _attemptsBehaviorSubject.add(newValue);
  set history(List<GameResult> newValue) =>
      _historyBehaviorSubject.add(newValue);

  void addGameResult(GameResult result) =>
      _historyBehaviorSubject.add([result, ...history]);
}
