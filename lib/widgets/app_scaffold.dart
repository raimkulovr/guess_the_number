import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    required this.platformIsIOS,
    required this.title,
  });

  final Widget child;
  final String title;
  final bool platformIsIOS;

  static const backgroundColor = Color.fromRGBO(246, 247, 248, 1);

  @override
  Widget build(BuildContext context) {
    Widget buildChild() => Builder(builder: (context) {
          return SafeArea(
            child: child,
          );
        });

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: platformIsIOS
          ? CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              backgroundColor: backgroundColor,
              child: buildChild(),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                forceMaterialTransparency: true,
                title: FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                backgroundColor: backgroundColor,
              ),
              backgroundColor: backgroundColor,
              body: buildChild(),
            ),
    );
  }
}
