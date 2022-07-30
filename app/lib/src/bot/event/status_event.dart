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

  StatusEvent(RawEvent raw)
      : health = raw.data['health'],
        food = double.parse(raw.data['food'].toString()),
        // in Minecraft, 1 tick is 20 seconds.
        time = Duration(seconds: (int.parse(raw.data['time']).toInt()) ~/ 20),
        inventoryItems = (raw.data['inventory_items'] as List<dynamic>)
            .map((item) => MinecraftItem.fromMap(item))
            .toList();
}
