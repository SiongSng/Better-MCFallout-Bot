import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

void main() {
  ConfigHelper.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '廢土伺服器機器人 V1.0.0 Beta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          useMaterial3: true),
      home: const HomePage(),
    );
  }
}
