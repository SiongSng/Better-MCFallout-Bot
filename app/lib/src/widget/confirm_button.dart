import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ConfirmButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          onPressed?.call();
        },
        child: const Text('確定'));
  }
}
