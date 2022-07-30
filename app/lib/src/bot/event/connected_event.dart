import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IConnectedEvent {
  String get host;
  int get port;
  String get gameVersion;
  String get uuid;
}

class ConnectedEvent implements IConnectedEvent, IEvent {
  @override
  late final String gameVersion;
  @override
  late final String host;
  @override
  late final int port;
  @override
  late final String uuid;

  ConnectedEvent(RawEvent raw)
      : gameVersion = raw.data['game_version'],
        host = raw.data['host'],
        port = raw.data['port'],
        uuid = raw.data['uuid'];
}
