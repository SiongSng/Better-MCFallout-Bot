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
        title: const Text('首頁'),
        centerTitle: true,
      ),
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    if ((appConfig.email?.isEmpty ?? true) ||
                        (appConfig.password?.isEmpty ?? true)) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('錯誤'),
                                content: const Text('請先設定帳號與密碼才能讓機器人登入廢土伺服器'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('確定')),
                                ],
                              ));
                    }

                    print(BotCore.getCoreExecutablePath());
                  },
                  label: const Text("啟動機器人"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  icon: const Icon(Icons.play_arrow))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const SettingsPage());
          },
          tooltip: '設定',
          child: const Icon(Icons.settings)),
    );
  }
}
