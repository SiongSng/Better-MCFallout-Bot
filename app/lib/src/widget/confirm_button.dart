import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('確定'));
  }
}
