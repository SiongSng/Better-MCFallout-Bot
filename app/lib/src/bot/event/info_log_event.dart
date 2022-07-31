import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IInfoLogEvent {
  String get message;
}

class InfoLogEvent implements IInfoLogEvent, IEvent {
  @override
  late final String message;

  InfoLogEvent(RawEvent event) : message = event.data['message'];
}
