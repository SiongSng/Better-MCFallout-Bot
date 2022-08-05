import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IConnectedEvent {
  String get host;
  int get port;
  String get gameVersion;
  String get uuid;
  String get name;
  DateTime get startAt;
}

class ConnectedEvent implements IConnectedEvent, IEvent {
  @override
  final String gameVersion;
  @override
  final String host;
  @override
  final int port;
  @override
  final String uuid;
  @override
  final String name;
  @override
  final DateTime startAt;

  ConnectedEvent(RawEvent event)
      : gameVersion = event.data['game_version'],
        host = event.data['host'],
        port = event.data['port'],
        uuid = event.data['uuid'],
        name = event.data['name'],
        startAt = DateTime.fromMillisecondsSinceEpoch(event.data['start_at']);
}
