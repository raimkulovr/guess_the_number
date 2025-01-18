import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.platformIsIOS,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  final bool platformIsIOS;
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return platformIsIOS
        ? CupertinoButton(
            onPressed: onPressed,
            color: CupertinoColors.activeBlue,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon),
                  ),
                Text(text),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(icon),
                  ),
              ],
            ),
          );
  }
}
