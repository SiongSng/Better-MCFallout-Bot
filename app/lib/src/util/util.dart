import 'dart:io';

import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Util {
  static String formatDuration(
    Duration duration, {
    bool forceShowSeconds = false,
    bool forceShowMinutes = false,
    bool forceShowHours = false,
    bool forceShowDays = false,
    bool forceShowYears = false,
    bool abbreviate = false,
  }) {
    String str = '';
    final int years = duration.inDays ~/ 365;
    final int days = duration.inDays % 365;
    final int hours = duration.inHours.remainder(Duration.hoursPerDay);
    final int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
    final int seconds = duration.inSeconds.remainder(Duration.secondsPerMinute);

    if (years > 0 || forceShowYears) {
      if (abbreviate) {
        str += '${years}y ';
      } else {
        str += '$years 年 ';
      }
    }

    if (days > 0 || forceShowDays) {
      if (abbreviate) {
        str += '${days}d ';
      } else {
        str += '$days 天 ';
      }
    }

    if (hours > 0 || forceShowHours) {
      if (abbreviate) {
        str += '${hours}h ';
      } else {
        str += '$hours 小時 ';
      }
    }
    if (minutes > 0 || forceShowMinutes) {
      if (abbreviate) {
        str += '${minutes}m ';
      } else {
        str += '$minutes 分鐘 ';
      }
    }
    if (seconds > 0 || forceShowSeconds) {
      if (abbreviate) {
        str += '${seconds}s';
      } else {
        str += '$seconds 秒 ';
      }
    }

    return str.trimRight();
  }

  static Future<void> openUri(String url) async {
    if (Platform.isLinux) {
      await xdgOpen(url);
    } else {
      await launchUrlString(url).catchError((e) {
        Logger.root.severe('Failed to open url: $url');
        return true;
      });
    }
  }

  static Future<ProcessResult?> xdgOpen(String uri) async {
    if (Platform.isLinux) {
      return await Process.run('xdg-open', [uri]);
    }
    return null;
  }

  static openFileManager(FileSystemEntity fse) async {
    if (fse is Directory) {
      if (!fse.existsSync()) {
        fse.createSync(recursive: true);
      }
    }

    if (Platform.isMacOS) {
      Process.run('open', [fse.absolute.path]);
    } else {
      openUri(Uri.decodeFull(fse.uri.toString()));
    }
  }

  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
