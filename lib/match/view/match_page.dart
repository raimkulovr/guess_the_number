import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guess_the_number/game_config.dart';
import 'package:guess_the_number/game_repository.dart';
import 'package:guess_the_number/widgets/widgets.dart';

import '../match.dart';
import 'match_result_alert_dialog.dart';

const _guessNumberFromOneTo = 'Угадай число от 1 до';
const _attemptsLeft = 'Попыток осталось:';
const _checkNum = 'Проверить';
const _checkedNums = 'Проверено:';
const _showHints = 'подсказать';
const _yourGuess = 'Ваша догадка:';

class MatchPage extends StatelessWidget {
  const MatchPage({
    super.key,
    required this.gameRepository,
  });

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchBloc(
        gameRepository: gameRepository,
      ),
      child: const MatchView(),
    );
  }
}

class MatchView extends StatelessWidget {
  const MatchView({super.key});

  void showResultDialog(
      BuildContext context, {
        required bool platformIsIOS,
        required bool matchWon,
  }) async {
    final restartGame = await showMatchResultAlertDialog(
      context,
      platformIsIOS: platformIsIOS,
      matchWon: matchWon,
    );

    if (restartGame != null) {
      if (restartGame) {
        context.read<MatchBloc>().add(MatchRestarted());
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MatchBloc>();
    final platformIsIOS = context.read<GuessTheNumberConfig>().platformIsIOS;

    final rangeEnd = bloc.rangeEnd;
    final maxAttempts = bloc.maxAttempts;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop == false) {
          bloc.add(MatchGiveUp());
          Navigator.of(context).pop();
        }
      },
      child: AppScaffold(
        platformIsIOS: platformIsIOS,
        title: '$_guessNumberFromOneTo $rangeEnd',
        child: BlocListener<MatchBloc, MatchState>(
          listenWhen: (p, c) => p.matchWon != c.matchWon,
          listener: (context, state) {
            if (state.matchWon != null) {
              showResultDialog(
                context,
                platformIsIOS: platformIsIOS,
                matchWon: state.matchWon!,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    spacing: 8,
                    children: [
                      BlocBuilder<MatchBloc, MatchState>(
                        buildWhen: (p, c) => p.attemptsLeft != c.attemptsLeft,
                        builder: (context, state) {
                          final attempts = state.attemptsLeft;
                          return Text('$_attemptsLeft $attempts');
                        },
                      ),
                      BlocBuilder<MatchBloc, MatchState>(
                        buildWhen: (p, c) => p.attemptsLeft != c.attemptsLeft,
                        builder: (context, state) {
                          final attempts = state.attemptsLeft;
                          return attempts <= 10
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List.generate(attempts, (_) => Icon(Icons.circle_outlined, color: Colors.grey)),
                                    ...List.generate((maxAttempts < 10 ? maxAttempts : 10) - attempts, (_) => Icon(Icons.close, color: Colors.red,),
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 24,
                                );
                        },
                      ),
                      _AttemptInput(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<MatchBloc, MatchState>(
                                buildWhen: (p, c) => p.attempt.displayError != c.attempt.displayError,
                                builder: (context, state) {
                                  return PrimaryButton(
                                    platformIsIOS: platformIsIOS,
                                    onPressed: state.attempt.displayError != null
                                        ? null
                                        : () => bloc.add(MatchAttemptUsed()),
                                    text: _checkNum,
                                  );
                                }),
                            _GenerateRandomNumbersOnAttemptInput(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(maxAttempts>=5)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: Column(
                      children: [
                        BlocBuilder<MatchBloc, MatchState>(
                            buildWhen: (p, c) => p.checkedValues.isNotEmpty != c.checkedValues.isNotEmpty || p.showHints != c.showHints,
                            builder: (context, state) {
                              return state.checkedValues.isNotEmpty
                                  ? Row(
                                      children: [
                                        Text(_checkedNums, textAlign: TextAlign.start,),
                                        Spacer(),
                                        if(!state.showHints)
                                          TextActionButton(
                                            onTap: ()=>bloc.add(MatchShowHints()),
                                            text: _showHints,
                                          )
                                      ],
                                    )
                                  : const SizedBox();
                            }
                        ),
                        const SizedBox(height: 8,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: BlocBuilder<MatchBloc, MatchState>(
                              buildWhen: (p, c) => p.checkedValues != c.checkedValues || p.showHints != c.showHints,
                              builder: (context, state) {
                                final checkedValues = state.checkedValues;
                                if(checkedValues.isNotEmpty){
                                  final latestAttempt = checkedValues.last;
                                  final shuffledCheckedValues = checkedValues.take(checkedValues.length-1).toList()..shuffle();
                                  final sampledCheckedValues = shuffledCheckedValues.take(100);
                                  final values = [latestAttempt, ...sampledCheckedValues];
                                  final generatedNumber=state.generatedNumber;
                                  return SingleChildScrollView(
                                    child: RichText(
                                        text: TextSpan(
                                            children: values.map((e) {
                                              return WidgetSpan(child:
                                              GestureDetector(
                                                onTap: () => bloc.add(MatchNewAttemptValueSet(attemptValue: e)),
                                                child: Text('$e ', style: TextStyle(
                                                    color: generatedNumber == e
                                                        ? Colors.green
                                                        : state.showHints
                                                        ? (e > generatedNumber ? Colors.red : Colors.blue).withValues(alpha: _calculateOpacity(generatedNumber, e))
                                                        : Colors.black
                                                )),
                                              ),

                                              );
                                            }).toList()
                                        )),
                                  );
                                }

                                return const SizedBox();
                              }
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttemptInput extends StatefulWidget {
  const _AttemptInput();

  @override
  State<_AttemptInput> createState() => _AttemptInputState();
}

class _AttemptInputState extends State<_AttemptInput> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    final initialValue = context.read<MatchBloc>().state.attempt.value;
    textEditingController =
        TextEditingController(text: '$initialValue'); // Set the initial value
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc, MatchState>(
      listener: (context, state) {
        textEditingController.text = state.attempt.value.toString();
      },
      buildWhen: (p, c) => p.attempt.displayError != c.attempt.displayError,
      builder: (context, state) {
        return NumInputField(
          platformIsIOS: context.read<GuessTheNumberConfig>().platformIsIOS,
          textEditingController: textEditingController,
          label: _yourGuess,
          onChanged: (value) {
            context
                .read<MatchBloc>()
                .add(MatchNewAttemptValueSet(attemptValue: value));
          },
          errorText: state.attempt.displayError,
        );
      },
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class _GenerateRandomNumbersOnAttemptInput extends StatelessWidget {
  const _GenerateRandomNumbersOnAttemptInput({super.key});

  @override
  Widget build(BuildContext context) {
    final platformIsIOS = context.read<GuessTheNumberConfig>().platformIsIOS;

    void onChanged([bool? value]) => context.read<MatchBloc>().add(MatchGenerateNumbersOnAttempt());

    return BlocBuilder<MatchBloc, MatchState>(
        buildWhen: (p, c) => p.generateRandomNumbersOnAttempt != c.generateRandomNumbersOnAttempt,
        builder: (context, state) {
          return GestureDetector(
            onTap: onChanged,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                platformIsIOS
                    ? CupertinoCheckbox(value: state.generateRandomNumbersOnAttempt, onChanged: onChanged,)
                    : Checkbox(value: state.generateRandomNumbersOnAttempt, onChanged: onChanged,),
                Text('Генерировать число при проверке'),
            ],),
          );
        });
  }
}

double _calculateOpacity(num target, num comparable) {
  final difference = (comparable - target).abs() / target;

  if (difference <= 0.05) {
    return 0.9;
  } else if (difference <= 0.1) {
    return 0.8;
  } else if (difference <= 0.3) {
    return 0.8 - ((difference - 0.1) / 0.2) * (0.8 - 0.6);
  } else if (difference <= 0.6) {
    return 0.6 - ((difference - 0.3) / 0.3) * (0.6 - 0.3);
  } else {
    return 0.3;
  }
}
