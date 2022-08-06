import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    await windowManager.setTitle('更好的廢土機器人 V${packageInfo.version}');
    SentryFlutter.setAppStartEnd(DateTime.now().toUtc());
    Logger.root.info('App started');

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      return await showDialog(
          context: NavigationService.navigatorKey.currentContext!,
          builder: (context) {
            return CheckDialog(
              message: '您確定要關閉本程式嗎？將會導致機器人強制斷線。',
              onPressedCancel: (context) {
                Navigator.of(context).pop(false);
              },
              onPressedOK: (context) {
                BotCore.instance?.disconnect();
                Navigator.of(context).pop(true);
              },
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '更好的廢土機器人',
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          fontFamily: 'font',
          tooltipTheme: TooltipThemeData(
            textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.black, fontSize: 13, fontFamily: 'font'),
            waitDuration: const Duration(milliseconds: 250),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white, primary: Colors.blue)),
          useMaterial3: true),
      home: const HomePage(),
    );
  }
}
