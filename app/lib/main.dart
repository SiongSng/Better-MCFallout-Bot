import 'dart:async';
import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await logging();
  Logger.root.info('App starting');
  await windowManager.ensureInitialized();
  await ConfigHelper.init();
  await analytics.init();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://6dcf85d7633043238a39a96b056c81d3@o1068024.ingest.sentry.io/6612655';

    FutureOr<SentryEvent?> beforeSend(SentryEvent event, {dynamic hint}) async {
      if (!kReleaseMode) return null;

      final MediaQueryData data =
          MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      final Size size = data.size;
      final List<String> githubSourceMap = [];
      final version = await Util.getAppVersion();

      final List<SentryException>? exceptions = event.exceptions;
      if (exceptions != null) {
        for (final exception in exceptions) {
          if (exception.stackTrace != null) {
            for (final frames in exception.stackTrace!.frames) {
              if ((frames.inApp ?? false) &&
                  frames.package == 'better_mcfallout_bot') {
                githubSourceMap.add(
                    'https://github.com/SiongSng/Better-MCFallout-Bot/blob/${kDebugMode ? 'main' : version}/app/${frames.absPath?.replaceAll('package:better_mcfallout_bot', 'lib/')}#L${frames.lineNo}');
              }
            }
          }
        }
      }
      final SentryEvent newEvent = event.copyWith(
          user: SentryUser(ipAddress: '{{auto}}'),
          extra: {
            'github_source_map': githubSourceMap,
            'dart_version': Platform.version,
            'config': appConfig.toMap(),
            'mode': kDebugMode ? 'debug' : 'release',
          },
          contexts: event.contexts.copyWith(
              device: SentryDevice(
            language: Platform.localeName,
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
    }

    options.beforeSend = beforeSend;
    options.tracesSampleRate = 1.0;
    options.autoAppStart = false;
    options.debug = kDebugMode;
  },
      appRunner: () => runApp(
          DefaultAssetBundle(bundle: SentryAssetBundle(), child: const App())));
}

Future<void> logging() async {
  final baseDir = await getApplicationSupportDirectory();
  final time = DateTime.now();
  final logFile = File(join(baseDir.path, 'logs',
      '${time.year}-${time.month}-${time.day}-${time.hour}-${time.minute}-${time.second}.log'));
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(record.toString());
    }

    if (record.level == Level.SEVERE) {
      Sentry.captureException(record.error ?? Exception(record.message),
          stackTrace: record.stackTrace);
    } else {
      Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.fromName(record.level.name.toLowerCase()),
        message: record.message,
        type: 'log',
        data: {
          'stack_trace': record.stackTrace.toString(),
          'logger_name': record.loggerName,
        },
        timestamp: record.time,
      ));
    }

    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
    String log = '[${record.time}] ${record.level.name}: ${record.message}';
    if (record.stackTrace != null) {
      log += '\n${record.stackTrace}';
    }

    logFile.writeAsStringSync('$log\n', mode: FileMode.append);
  });
}
