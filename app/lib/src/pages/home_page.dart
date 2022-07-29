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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "請先登入帳號",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            TextButton.icon(
                onPressed: () {},
                label: const Text("啟動機器人"),
                icon: const Icon(Icons.play_arrow))
          ],
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
