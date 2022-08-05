import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IErrorLogEvent {
  String get message;
}

class ErrorLogEvent implements IErrorLogEvent, IEvent {
  @override
  final String message;

  ErrorLogEvent(RawEvent event) : message = event.data['message'];
}
