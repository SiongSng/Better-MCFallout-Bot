import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

abstract class IStatusEvent {
  int get ping;
  int get health;
  double get foodSaturation;
  Duration get time;
  List<MinecraftItem> get inventoryItems;
}

class StatusEvent implements IStatusEvent, IEvent {
  @override
  late final int ping;
  @override
  late final int health;
  @override
  late final double foodSaturation;
  @override
  late final Duration time;
  @override
  late final List<MinecraftItem> inventoryItems;

  StatusEvent(RawEvent raw)
      : ping = raw.data['ping'],
        health = raw.data['health'],
        foodSaturation = raw.data['food_saturation'],
        // in Minecraft, 1 tick is 20 seconds.
        time = Duration(seconds: (int.parse(raw.data['time']).toInt()) ~/ 20),
        inventoryItems = (raw.data['inventory_items'] as List<dynamic>)
            .map((item) => MinecraftItem.fromMap(item))
            .toList();
}
