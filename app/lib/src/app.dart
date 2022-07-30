import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:logging/logging.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    Logger.root.info('App started');

    super.initState();

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      return await showDialog(
          context: NavigationService.navigatorKey.currentState!.context,
          builder: (context) {
            return AlertDialog(
                title: const Text('資訊'),
                content: const Text('您確定要關閉本程式嗎？將會導致機器人強制斷線。'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('否')),
                  TextButton(
                      onPressed: () {
                        BotCore.instance?.disconnect();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('是')),
                ]);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '廢土伺服器機器人 V1.0.0 Beta',
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          fontFamily: 'font',
          tooltipTheme: TooltipThemeData(
            textStyle: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.black, fontSize: 13),
            waitDuration: const Duration(milliseconds: 250),
          ),
          useMaterial3: true),
      home: const HomePage(),
    );
  }
}
