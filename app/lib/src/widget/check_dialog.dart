import 'package:flutter/material.dart';

class CheckDialog extends StatelessWidget {
  final String title;
  final String? message;
  final void Function(BuildContext context) onPressedOK;
  final void Function(BuildContext context)? onPressedCancel;

  const CheckDialog({
    Key? key,
    this.title = '資訊',
    this.message,
    required this.onPressedOK,
    this.onPressedCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message != null ? Text(message!) : null,
      actions: [
        ElevatedButton(
          child: const Text('否'),
          onPressed: () {
            if (onPressedCancel != null) {
              onPressedCancel?.call(context);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        ElevatedButton(
            onPressed: () {
              onPressedOK(context);
            },
            child: const Text('是')),
      ],
    );
  }
}
