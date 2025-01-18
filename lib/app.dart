import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_the_number/home/home.dart';

import 'game_config.dart';
import 'game_repository.dart';

class GuessTheNumber extends StatelessWidget {
  const GuessTheNumber({
    super.key,
    required this.gameRepository,
    required this.config,
  });

  final GuessTheNumberConfig config;
  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: gameRepository),
          RepositoryProvider.value(value: config),
        ],
        child: config.platformIsIOS
            ? CupertinoApp(
                theme: CupertinoThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.white,
                  primaryContrastingColor: Colors.black,
                  textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                debugShowCheckedModeBanner: false,
                home: HomePage(gameRepository),
              )
            : MaterialApp(
                themeMode: ThemeMode.light,
                theme: ThemeData(
                  // useMaterial3: true,
                  primaryColor: Colors.white,
                  fontFamily: 'Inter',
                ),
                debugShowCheckedModeBanner: false,
                home: HomePage(gameRepository),
              ));
  }
}
