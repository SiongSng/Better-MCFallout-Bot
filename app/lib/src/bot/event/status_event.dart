import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IStatusEvent {
  double get health;
  double get food;
  Duration get time;
  List<MinecraftItem> get inventoryItems;
}

class StatusEvent implements IStatusEvent, IEvent {
  @override
  final double health;
  @override
  final double food;
  @override
  final Duration time;
  @override
  final List<MinecraftItem> inventoryItems;

  StatusEvent(RawEvent event)
      : health = double.parse(event.data['health'].toString()),
        food = double.parse(event.data['food'].toString()),
        // in Minecraft, 1 tick is 20 seconds.
        time = Duration(seconds: (int.parse(event.data['time']).toInt()) ~/ 20),
        inventoryItems = (event.data['inventory_items'] as List<dynamic>)
            .map((item) => MinecraftItem.fromMap(item))
            .toList();
}
