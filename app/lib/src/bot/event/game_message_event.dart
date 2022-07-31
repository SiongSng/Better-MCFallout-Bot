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

  GameMessageEvent(RawEvent event)
      : message = event.data['message'],
        sentAt = DateTime.fromMillisecondsSinceEpoch(event.data['sent_at']);
}
