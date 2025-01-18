import 'dart:io';
import 'dart:developer';
import 'package:flutter/widgets.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'game_config.dart';
import 'game_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  Bloc.observer = SimpleBlocObserver();
  final gameRepository = GameRepository();

  runApp(GuessTheNumber(
    gameRepository: gameRepository,
    config: GuessTheNumberConfig(
      platformIsIOS: Platform.isIOS,
    ),
  ));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('${bloc.runtimeType} $error $stackTrace');
  }
}
