import 'package:flutter/material.dart';

class TextActionButton extends StatelessWidget {
  const TextActionButton({super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Text(text, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
    );
  }

}
