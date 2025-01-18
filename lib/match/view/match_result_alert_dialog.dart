import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _restart = 'Начать игру заново';
const _win = 'Победа';
const _noAttempts = 'Попытки закончились';

Future<bool?> showMatchResultAlertDialog(
  BuildContext context, {
  required bool platformIsIOS,
  required bool matchWon,
}) async {
  final size = MediaQuery.sizeOf(context);

  final featureColor = matchWon ? Colors.green : Colors.red;
  Widget buildTitle() => Text(
        matchWon ? _win : _noAttempts,
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
        textAlign: TextAlign.center,
      );

  Widget buildDialog(BuildContext dialogContext) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (result == null) {
            Navigator.of(dialogContext).pop(false);
          }
        },
        child: Dialog(
          backgroundColor: featureColor,
          child: SizedBox(
            height: size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      icon: Icon(platformIsIOS
                          ? CupertinoIcons.back
                          : Icons.arrow_back_rounded)),
                ),
                Expanded(
                  child: Center(child: buildTitle()),
                ),
                Divider(
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(true),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _restart,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  late final bool? restartGame;

  if (platformIsIOS) {
    restartGame = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return buildDialog(dialogContext);
      },
    );
  } else {
    restartGame = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return buildDialog(dialogContext);
      },
    );
  }

  return restartGame;
}
