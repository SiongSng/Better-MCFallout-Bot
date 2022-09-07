import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

BotCore? _instance;
final Logger _logger = Logger('bot_core');

class BotCore {
  static BotCore? get instance {
    return _instance;
  }

  final String host;
  final int port;
  final Account account;
  int reconnectTimes;

  late Process process;
  late Stream<IEvent> eventStream;
  late ConnectedEvent connectedData;
  bool connected = false;

  BotCore.createBot(
      {required this.host,
      required this.port,
      required this.account,
      this.reconnectTimes = 0}) {
    _instance = this;
  }

  Future<bool> connect() async {
    if (connected) return true;
    try {
      // Not the first time to reconnect
      if (reconnectTimes > 1) {
        await Future.delayed(const Duration(seconds: 15));
      }

      await _connect().timeout(const Duration(seconds: 20));
      // Successful to reconnect, so reset reconnect times
      reconnectTimes > 0 ? reconnectTimes-- : reconnectTimes = 0;
      return true;
    } on TimeoutException {
      return false;
    }
  }

  void disconnect() {
    if (!connected) return;
    _executeAction(const BotAction(action: BotActionType.disconnect));
    process.kill(ProcessSignal.sigkill);
    connected = false;
    _logger.info('The bot was manually disconnected');
  }

  void whenEvent<E extends IEvent>(void Function(E event) callback) {
    late final StreamSubscription subscription;

    subscription = eventStream.listen((event) async {
      if (event is E) {
        callback(event);
      }

      if (event is DisconnectedEvent) {
        await subscription.cancel();
      }
    });
  }

  Stream<E> whenEventStream<E extends IEvent>() {
    final StreamController<E> controller = StreamController<E>();

    whenEvent<E>((event) {
      controller.add(event);
    });

    return controller.stream.asBroadcastStream();
  }

  void runCommand(String command) {
    if (!connected) return;
    _executeAction(BotAction(
        action: BotActionType.command, argument: {'command': command}));
  }

  void updateConfig() {
    if (!connected) return;
    _executeAction(BotAction(
        action: BotActionType.updateConfig,
        argument: {'config': _getConfig()}));
  }

  void attack(BotActionMethod method) {
    if (!connected) return;
    _executeAction(BotAction(action: BotActionType.attack, method: method));
  }

  Future<void> _connect() async {
    final config = _getConfig();

    process = await Process.start(_getExecutablePath(), [json.encode(config)]);
    eventStream = _listen();
    _logging();

    whenEvent<ConnectedEvent>((event) {
      connected = true;
      connectedData = event;
      _logger.info('Connected to $host:$port');
    });

    // Wait for connecting to the server
    while (!connected) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Stream<IEvent> _listen() {
    late final StreamController<IEvent> controller;

    final stdout = process.stdout.listen((data) {
      final text = utf8.decode(data);
      try {
        final List<String> jsonList = LineSplitter.split(text).toList();

        for (final String json in jsonList) {
          if (json.isEmpty) return;
          final RawEvent event = RawEvent.fromJson(json);

          final handledEvent = _eventHandler(event);
          if (handledEvent != null) {
            controller.add(handledEvent);
          }
        }
      } catch (e) {
        if (text.contains('ECONNRESET')) {
          controller.add(DisconnectedEvent.create(text));
          return;
        }

        _logger.warning('Failed to parse event: $e ($text)');
      }
    });

    controller = StreamController<IEvent>(
      onCancel: () => stdout.cancel(),
      onResume: () => stdout.resume(),
      onPause: () => stdout.pause(),
    );

    process.stderr.listen((data) {
      final String error = utf8.decode(data);
      _logger.severe(error, null, StackTrace.current);
    });

    return controller.stream.asBroadcastStream();
  }

  IEvent? _eventHandler(RawEvent event) {
    switch (event.event) {
      case EventType.connected:
        connected = true;
        return ConnectedEvent(event);
      case EventType.disconnected:
        connected = false;
        return DisconnectedEvent(event);
      case EventType.info:
        return InfoLogEvent(event);
      case EventType.warn:
        return WarnLogEvent(event);
      case EventType.error:
        return ErrorLogEvent(event);
      case EventType.gameMessage:
        return GameMessageEvent(event);
      case EventType.status:
        return StatusEvent(event);
      default:
        _logger.warning('Unknown event: ${event.event}');
        return null;
    }
  }

  void _executeAction(BotAction action) {
    process.stdin.writeln(json.encode(action.toMap()));
  }

  void _logging() {
    whenEvent<InfoLogEvent>((event) {
      _logger.info(event.message);
    });

    whenEvent<WarnLogEvent>((event) {
      _logger.warning(event.message);
    });

    whenEvent<ErrorLogEvent>((event) {
      _logger.severe(event.message);
    });
  }

  Map _getConfig() => {
        'host': host,
        'port': port,
        'username': account.username,
        'token': account.minecraftToken,
        'uuid': account.uuid,
        'auto_eat': appConfig.autoEat,
        'auto_throw': appConfig.autoThrow,
        'warp_publicity': appConfig.warpPublicity,
        'trade_publicity': appConfig.tradePublicity,
        'allow_tpa': appConfig.allowTpa,
        'attack_interval_ticks': appConfig.attackIntervalTicks,
      };

  String _getExecutablePath() {
    final String file;
    if (Platform.isWindows) {
      file = 'better-mcfallout-bot-core.exe';
    } else {
      file = 'better-mcfallout-bot-core';
    }
    final String path;

    if (kDebugMode) {
      path = join(dirname(Directory.current.path), 'core', 'out', file);
    } else {
      final basePath = join('flutter_assets', 'assets', file);

      if (Platform.isWindows || Platform.isLinux) {
        path = join(dirname(Platform.resolvedExecutable), 'data', basePath);
      } else if (Platform.isMacOS) {
        path = join(dirname(dirname(Platform.resolvedExecutable)), 'Frameworks',
            'App.framework', 'Versions', 'A', 'Resources', basePath);
      } else {
        throw Exception(
            'Failed to find core executable, unsupported platform: ${Platform.operatingSystem}');
      }
    }

    return path;
  }
}
