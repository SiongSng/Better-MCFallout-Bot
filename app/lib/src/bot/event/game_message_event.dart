import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IGameMessageEvent {
  String get message;
  DateTime get sentAt;
}

class GameMessageEvent implements IGameMessageEvent, IEvent {
  @override
  late final String message;
  @override
  late final DateTime sentAt;

  GameMessageEvent(RawEvent raw)
      : message = raw.data['message'],
        sentAt = DateTime.fromMillisecondsSinceEpoch(raw.data['sent_at']);
}
