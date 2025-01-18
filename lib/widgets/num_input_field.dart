import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumInputField extends StatelessWidget {
  const NumInputField({
    super.key,
    required this.platformIsIOS,
    required this.textEditingController,
    required this.label,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController textEditingController;
  final String label;
  final ValueChanged<int> onChanged;
  final String? errorText;
  final bool platformIsIOS;

  @override
  Widget build(BuildContext context) {
    return platformIsIOS
        ? Column(
            children: [
              errorText != null
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        errorText!,
                        style: TextStyle(color: CupertinoColors.systemRed),
                      ),
                    )
                  : const SizedBox(
                      height: 21,
                    ),
              CupertinoTextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                onChanged: (value) {
                  onChanged(int.tryParse(value) ?? 0);
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                style: TextStyle(
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: errorText != null
                          ? CupertinoColors.systemRed
                          : CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          )
        : TextField(
            controller: textEditingController,
            onChanged: (value) {
              onChanged(int.tryParse(value) ?? 0);
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              labelText: label,
              errorText: errorText,
            ),
          );
  }
}
