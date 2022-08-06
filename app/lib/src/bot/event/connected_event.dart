import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IConnectedEvent {
  String get host;
  int get port;
  String get gameVersion;
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
  final DateTime startAt;

  ConnectedEvent(RawEvent event)
      : gameVersion = event.data['game_version'],
        host = event.data['host'],
        port = event.data['port'],
        startAt = DateTime.fromMillisecondsSinceEpoch(event.data['start_at']);
}
