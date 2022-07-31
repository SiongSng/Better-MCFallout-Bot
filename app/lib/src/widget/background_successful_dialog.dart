import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class BackgroundSuccessfulDialog extends StatelessWidget {
  const BackgroundSuccessfulDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('資訊'),
      content: Text('背景圖片設定成功，請重新啟動本軟體新的背景圖片才會生效'),
      actions: [ConfirmButton()],
    );
  }
}
