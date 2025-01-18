import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guess_the_number/game_repository.dart';
import 'package:guess_the_number/widgets/widgets.dart';

import '../history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
    required this.gameRepository,
  });

  final GameRepository gameRepository;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(gameRepository: gameRepository),
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
        buildWhen: (p, c) => p.results.isNotEmpty != c.results.isNotEmpty,
        builder: (context, state) {
          return state.results.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('История'),
                          Spacer(),
                          TextActionButton(
                            onTap: () =>
                                context.read<HistoryCubit>().resetHistory(),
                            text: 'очистить',
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: BlocBuilder<HistoryCubit, HistoryState>(
                          buildWhen: (p, c) => p.results != c.results,
                          builder: (context, state) {
                            final data = [
                              _HistoryEntryBase(
                                children: [
                                  ...[
                                    ('Конец диапазона', 'К.Д.'),
                                    ('Кол-во попыток', 'К.П.'),
                                    ('Использовано попыток', 'И.П.'),
                                  ].map(
                                    (e) => Expanded(
                                      flex: 2,
                                      child: Tooltip(
                                          message: e.$1, child: Text(e.$2)),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: SizedBox()),
                                  Expanded(flex: 5, child: SizedBox()),
                                ],
                              ),
                              ...state.results
                            ];
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final e = data[index];
                                return e is Widget ? e : _HistoryEntry(e as GameResult);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}

class _HistoryEntryBase extends StatelessWidget {
  const _HistoryEntryBase({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          spacing: 8,
          children: children,
        ));
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry(this.result, {super.key});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: result.didWin
              ? [
                  Colors.transparent,
                  Colors.greenAccent.withOpacity(0.1),
                  Colors.greenAccent.withOpacity(0.2),
                  Colors.green.withOpacity(0.8)
                ]
              : [
                  Colors.transparent,
                  Colors.redAccent.withOpacity(0.1),
                  Colors.redAccent.withOpacity(0.2),
                  Colors.red.withOpacity(0.8)
                ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: _HistoryEntryBase(children: [
        ...[
          result.rangeEnd,
          result.allowedAttempts,
          result.usedAttempts
        ].map((e) => Expanded(
            flex: 2,
            child: Tooltip(
                message: '$e',
                child:
                    Text('$e', softWrap: false, overflow: TextOverflow.fade)))),
        Expanded(
          flex: 1,
          child: Tooltip(
              message: 'Были использованы подсказки',
              child: Text(result.withHints ? '🐣' : ' ')),
        ),
        Expanded(
          flex: 5,
          child: TimeAgo(DateTime.fromMillisecondsSinceEpoch(result.timestamp)),
        ),
      ]),
    );
  }
}
