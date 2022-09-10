import 'dart:io';
import 'dart:math';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final analytics = Analytics();

class Analytics {
  final trackingId = 'G-660VJMJ3X5';

  Future<void> init() async {
    final clientID = appConfig.analyticsClientId;

    if (clientID == null) {
      appConfig.analyticsClientId =
          '${Random().nextInt(0x7FFFFFFF)}.${DateTime.now().millisecondsSinceEpoch / 1000}';
      await firstVisit();
    }

    await ping();
  }

  Future<void> ping() async {
    await _sendEvent(event: 'user_engagement');
  }

  Future<void> firstVisit() async {
    await _sendEvent(event: 'first_visit');
  }

  Future<void> pageView(String page) async {
    await _sendEvent(event: 'page_view', params: {'page_title': page});
  }

  Future<void> _sendEvent(
      {required String event, Map<String, String>? params}) async {
    final size = WidgetsBinding.instance.window.physicalSize;

    final uri = Uri(
        scheme: 'https',
        host: 'www.google-analytics.com',
        path: '/g/collect',
        queryParameters: {
          'v': '2', // protocol version
          'sr':
              '${size.width.toInt()}x${size.height.toInt()}', // screen resolution
          'ul': _getPlatformLocale(), // user language
          'cid': appConfig.analyticsClientId, // client id,
          'tid': trackingId,
          'uid': appConfig.analyticsClientId, // user id,
          'an': 'Better MCFallout Bot',
          'av': await Util.getAppVersion(),
        });

    try {
      await post(uri,
          headers: {'User-Agent': await _getUserAgent()},
          body: _formatData(event, params));
    } catch (e) {
      Logger.root.warning('Failed to send analytics event: $e');
    }
  }

  String _formatData(String event, Map<String, String>? params) {
    String data = '';
    List<String> list = [event];
    if (params != null) {
      params.forEach((key, value) {
        list.add('$key=$value');
      });
    }
    data = 'en=${list.join('&')}\n';
    return data;
  }

  Future<String> _getUserAgent() async {
    final locale = _getPlatformLocale();
    final version = await Util.getAppVersion();

    if (Platform.isAndroid) {
      return 'RPMLauncher/$version (Android; Mobile; $locale)';
    } else if (Platform.isIOS) {
      return 'RPMLauncher/$version (iPhone; U; CPU iPhone OS like Mac OS X; $locale)';
    } else if (Platform.isMacOS) {
      return 'RPMLauncher/$version (Macintosh; Intel Mac OS X; Macintosh; $locale)';
    } else if (Platform.isWindows) {
      return 'RPMLauncher/$version (Windows; Windows; Windows; $locale)';
    } else if (Platform.isLinux) {
      return 'RPMLauncher/$version (Linux; Linux; Linux; $locale)';
    } else {
      // Dart/1.8.0 (macos; macos; macos; en_US)
      var os = Platform.operatingSystem;
      return 'Dart/${Platform.version} ($os; $os; $os; $locale)';
    }
  }

  String _getPlatformLocale() {
    String locale = Platform.localeName;

    // Convert `en_US.UTF-8` to `en_US`.
    final index = locale.indexOf('.');
    if (index != -1) locale = locale.substring(0, index);

    // Convert `en_US` to `en-us`.
    locale = locale.replaceAll('_', '-').toLowerCase();

    return locale;
  }
}
