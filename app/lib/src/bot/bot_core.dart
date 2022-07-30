import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class BotCore {
  static String getCoreExecutablePath() {
    String path;
    if (kReleaseMode) {
      path = join(dirname(Platform.resolvedExecutable), 'lib',
          'better-mcfallout-bot-core');
    } else {
      path = join(dirname(Directory.current.path), 'core', 'out',
          'better-mcfallout-bot');
    }

    return path;
  }
}
