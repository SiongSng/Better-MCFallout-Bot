import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const SettingsPage());
                },
                tooltip: '設定',
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AboutPage());
                },
                tooltip: '關於',
                icon: const Icon(Icons.info))
          ],
        ),
        leadingWidth: 50 * 2,
        title: const Text('更好的廢土機器人'),
        centerTitle: true,
      ),
      body: Background(child: Container()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if ((appConfig.email?.isEmpty ?? true) ||
                (appConfig.password?.isEmpty ?? true)) {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        title: Text('錯誤'),
                        content: Text('請先設定帳號與密碼才能讓機器人登入廢土伺服器'),
                        actions: [ConfirmButton()],
                      ));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const ConnectingServer());
            }
          },
          tooltip: '啟動機器人',
          child: const Icon(Icons.play_arrow)),
    );
  }
}
