import 'dart:async';
import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  ConfigHelper.init();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://6dcf85d7633043238a39a96b056c81d3@o1068024.ingest.sentry.io/6612655';

    FutureOr<SentryEvent?> beforeSend(SentryEvent event, {dynamic hint}) async {
      if (kReleaseMode) {
        MediaQueryData data =
            MediaQueryData.fromWindow(WidgetsBinding.instance.window);
        Size size = data.size;
        SentryEvent newEvent;
        List<String> githubSourceMap = [];
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        List<SentryException>? exceptions = event.exceptions;
        if (exceptions != null) {
          for (final exception in exceptions) {
            if (exception.stackTrace != null) {
              for (final frames in exception.stackTrace!.frames) {
                if ((frames.inApp ?? false) &&
                    frames.package == 'better_mcfallout_bot') {
                  githubSourceMap.add(
                      'https://github.com/SiongSng/Better-MCFallout-Bot/blob/${kDebugMode ? 'main' : packageInfo.version}/${frames.absPath?.replaceAll('package:better_mcfallout_bot', 'lib/')}#L${frames.lineNo}');
                }
              }
            }
          }
        }
        newEvent = event.copyWith(
            user:
                SentryUser(username: Platform.environment['USERNAME'], extras: {
              'github_source_map': githubSourceMap,
              'dart_version': Platform.version,
              'config': appConfig.toMap()
            }),
            contexts: event.contexts.copyWith(
                device: SentryDevice(
              language: Platform.localeName,
              name: Platform.localHostname,
              simulator: false,
              screenHeightPixels: size.height.toInt(),
              screenWidthPixels: size.width.toInt(),
              screenDensity: data.devicePixelRatio,
              online: true,
              screenDpi: (data.devicePixelRatio * 160).toInt(),
              screenResolution: '${size.width}x${size.height}',
              timezone: DateTime.now().timeZoneName,
            )),
            exceptions: exceptions);

        return newEvent;
      } else {
        return null;
      }
    }

    options.beforeSend = beforeSend;
    options.tracesSampleRate = 1.0;
  }, appRunner: () => runApp(const App()));
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
