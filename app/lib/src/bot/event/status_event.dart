import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IStatusEvent {
  int get health;
  double get food;
  Duration get time;
  List<MinecraftItem> get inventoryItems;
}

class StatusEvent implements IStatusEvent, IEvent {
  @override
  late final int health;
  @override
  late final double food;
  @override
  late final Duration time;
  @override
  late final List<MinecraftItem> inventoryItems;

  StatusEvent(RawEvent event)
      : health = event.data['health'],
        food = double.parse(event.data['food'].toString()),
        // in Minecraft, 1 tick is 20 seconds.
        time = Duration(seconds: (int.parse(event.data['time']).toInt()) ~/ 20),
        inventoryItems = (event.data['inventory_items'] as List<dynamic>)
            .map((item) => MinecraftItem.fromMap(item))
            .toList();
}
