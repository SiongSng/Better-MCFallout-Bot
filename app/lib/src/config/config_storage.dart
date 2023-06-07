import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

const ConfigStorage appConfig = ConfigStorage();

class ConfigStorage {
  const ConfigStorage();

  String? get analyticsClientId =>
      ConfigHelper.get<String>('analytics_client_id');
  set analyticsClientId(String? value) =>
      ConfigHelper.set<String>('analytics_client_id', value);

  ServerRegion get region =>
      ServerRegion.values.byName(ConfigHelper.get<String>('region',
          defaultValue: ServerRegion.defaultRegion.name)!);
  set region(ServerRegion value) =>
      ConfigHelper.set<String>('region', value.name);

  bool get autoEat => ConfigHelper.get<bool>('auto_eat', defaultValue: false)!;
  set autoEat(bool value) => ConfigHelper.set<bool>('auto_eat', value);

  bool get autoThrow =>
      ConfigHelper.get<bool>('auto_throw', defaultValue: false)!;
  set autoThrow(bool value) => ConfigHelper.set<bool>('auto_throw', value);

  bool get autoDeposit =>
      ConfigHelper.get<bool>('auto_deposit',defaultValue: false)!;
  set autoDeposit(bool value) => ConfigHelper.set<bool>('auto_deposit',value);

  bool get autoReconnect =>
      ConfigHelper.get<bool>('auto_reconnect', defaultValue: true)!;
  set autoReconnect(bool value) =>
      ConfigHelper.set<bool>('auto_reconnect', value);

  BotActionType get botAction =>
      BotActionType.values.byName(ConfigHelper.get<String>('bot_action_type',
          defaultValue: BotActionType.afk.name)!);
  set botAction(BotActionType value) =>
      ConfigHelper.set<String>('bot_action_type', value.name);

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

  List<String> get allowTpa =>
      ConfigHelper.get<List>('allow_tpa', defaultValue: [])!.cast();
  set allowTpa(List<String> value) =>
      ConfigHelper.set<List<String>>('allow_tpa', value);

  int get attackIntervalTicks =>
      ConfigHelper.get<int>('attack_interval_ticks', defaultValue: 12)!;
  set attackIntervalTicks(int value) =>
      ConfigHelper.set<int>('attack_interval_ticks', value);

  Map toMap() => {
        'region': region.name,
        'auto_eat': autoEat,
        'auto_throw': autoThrow,
        'auto_reconnect': autoReconnect,
        'bot_action_type': botAction.name,
        'background_path': backgroundPath,
        'warp_publicity': warpPublicity,
        'trade_publicity': tradePublicity,
        //'hide_health': hideHealth,
        'attack_interval_ticks': attackIntervalTicks,
      };
}
