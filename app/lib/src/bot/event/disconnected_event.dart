import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IDisconnectedEvent {
  String get reason;
}

class DisconnectedEvent implements IDisconnectedEvent, IEvent {
  @override
  final String reason;

  DisconnectedEvent(RawEvent event) : reason = event.data['reason'];
}
