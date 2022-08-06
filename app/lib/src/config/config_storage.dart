import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

const ConfigStorage appConfig = ConfigStorage();

class ConfigStorage {
  const ConfigStorage();

  ServerRegion get region =>
      ServerRegion.values.byName(ConfigHelper.get<String>('region',
          defaultValue: ServerRegion.auto.name)!);
  set region(ServerRegion value) =>
      ConfigHelper.set<String>('region', value.name);

  bool get autoEat => ConfigHelper.get<bool>('auto_eat', defaultValue: false)!;
  set autoEat(bool value) => ConfigHelper.set<bool>('auto_eat', value);

  bool get autoThrow =>
      ConfigHelper.get<bool>('auto_throw', defaultValue: false)!;
  set autoThrow(bool value) => ConfigHelper.set<bool>('auto_throw', value);

  bool get autoReconnect =>
      ConfigHelper.get<bool>('auto_reconnect', defaultValue: true)!;
  set autoReconnect(bool value) =>
      ConfigHelper.set<bool>('auto_reconnect', value);

  BotActionType get botAction =>
      BotActionType.values.byName(ConfigHelper.get<String>('bot_action',
          defaultValue: BotActionType.none.name)!);
  set botAction(BotActionType value) =>
      ConfigHelper.set<String>('bot_action', value.name);

  String? get backgroundPath => ConfigHelper.get<String>('background_path');
  set backgroundPath(String? value) =>
      ConfigHelper.set<String>('background_path', value);

  // 公共設施頻道自動宣傳
  String? get warpPublicity => ConfigHelper.get<String>('warp_publicity');
  set warpPublicity(String? value) =>
      ConfigHelper.set<String>('warp_publicity', value);

  // 交易頻道自動宣傳
  String? get tradePublicity => ConfigHelper.get<String>('trade_publicity');
  set tradePublicity(String? value) =>
      ConfigHelper.set<String>('trade_publicity', value);

  bool get hideHealth =>
      ConfigHelper.get<bool>('hide_health', defaultValue: true)!;
  set hideHealth(bool value) => ConfigHelper.set<bool>('hide_health', value);

  List<String> get allowTpa =>
      ConfigHelper.get<List>('allow_tpa', defaultValue: [])!.cast();
  set allowTpa(List<String> value) =>
      ConfigHelper.set<List<String>>('allow_tpa', value);

  Map toMap() => {
        'region': region.name,
        'auto_eat': autoEat,
        'auto_throw': autoThrow,
        'auto_reconnect': autoReconnect,
        'bot_action': botAction.name,
        'background_path': backgroundPath,
        'warp_publicity': warpPublicity,
        'trade_publicity': tradePublicity,
        'hide_health': hideHealth,
      };
}
