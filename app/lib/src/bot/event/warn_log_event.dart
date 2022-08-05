import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IWarnLogEvent {
  String get message;
}

class WarnLogEvent implements IWarnLogEvent, IEvent {
  @override
  final String message;

  WarnLogEvent(RawEvent event) : message = event.data['message'];
}
