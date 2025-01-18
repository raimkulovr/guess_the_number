import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guess_the_number/match/match.dart';
import 'package:guess_the_number/game_config.dart';
import 'package:guess_the_number/game_repository.dart';
import 'package:guess_the_number/history/history.dart';
import 'package:guess_the_number/widgets/widgets.dart';

import '../home.dart';

const _guessNumber = 'Угадай число';
const _startGame = 'Начать игру';
const _attempts = 'Попытки';
const _rangeEnd = 'Конец диапазона';

class HomePage extends StatelessWidget {
  const HomePage(this.gameRepository, {super.key});

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => HomeBloc(gameRepository: gameRepository),
        child: const HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _guessNumber,
      platformIsIOS: context.read<GuessTheNumberConfig>().platformIsIOS,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _AttemptsInput(),
                  const SizedBox(
                    height: 4,
                  ),
                  _RangeEndInput(),
                  Expanded(
                    child: Center(
                      child: StartGameButton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          HistoryPage(gameRepository: context.read<GameRepository>()),
        ],
      ),
    );
  }
}

class StartGameButton extends StatelessWidget {
  const StartGameButton({super.key});

  void startGame(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => RepositoryProvider.value(
              value: context.read<GuessTheNumberConfig>(),
              child: MatchPage(gameRepository: context.read<GameRepository>()),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final platformIsIos = context.read<GuessTheNumberConfig>().platformIsIOS;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) => p.canStartGame != c.canStartGame,
      builder: (context, state) {
        final canStartGame = state.canStartGame;
        return PrimaryButton(
          platformIsIOS: platformIsIos,
          onPressed: canStartGame ? () => startGame(context) : null,
          text: _startGame,
          icon: platformIsIos
              ? CupertinoIcons.play_arrow_solid
              : Icons.play_arrow,
        );
      },
    );
  }
}

class _AttemptsInput extends StatefulWidget {
  const _AttemptsInput();

  @override
  State<_AttemptsInput> createState() => _AttemptsInputState();
}

class _AttemptsInputState extends State<_AttemptsInput> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    final initialValue = context.read<HomeBloc>().state.attempts.value;
    textEditingController =
        TextEditingController(text: '$initialValue'); // Set the initial value
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        textEditingController.text = state.attempts.value.toString();
      },
      buildWhen: (p, c) => p.attempts.displayError != c.attempts.displayError,
      builder: (context, state) {
        return NumInputField(
          platformIsIOS: context.read<GuessTheNumberConfig>().platformIsIOS,
          textEditingController: textEditingController,
          label: _attempts,
          onChanged: (value) {
            context.read<HomeBloc>().add(HomeNewAttemptsSet(attempts: value));
          },
          errorText: state.attempts.displayError,
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

class _RangeEndInput extends StatefulWidget {
  const _RangeEndInput();

  @override
  State<_RangeEndInput> createState() => _RangeEndInputState();
}

class _RangeEndInputState extends State<_RangeEndInput> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    final initialValue = context.read<HomeBloc>().state.rangeEnd.value;
    textEditingController = TextEditingController(text: '$initialValue');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (p, c) => p.rangeEnd != c.rangeEnd,
      listener: (context, state) {
        textEditingController.text = state.rangeEnd.value.toString();
      },
      buildWhen: (p, c) => p.rangeEnd.displayError != c.rangeEnd.displayError,
      builder: (context, state) {
        return NumInputField(
          platformIsIOS: context.read<GuessTheNumberConfig>().platformIsIOS,
          textEditingController: textEditingController,
          label: _rangeEnd,
          onChanged: (value) {
            context.read<HomeBloc>().add(HomeNewRangeEndSet(rangeEnd: value));
          },
          errorText: state.rangeEnd.displayError,
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
