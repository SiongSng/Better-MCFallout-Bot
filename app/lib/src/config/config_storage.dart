import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

ConfigStorage appConfig = const ConfigStorage();

class ConfigStorage {
  const ConfigStorage();

  ServerRegion get region => ServerRegion.values
      .byName(ConfigHelper.get('region') ?? ServerRegion.auto.name);
  set region(ServerRegion value) => ConfigHelper.set('region', value.name);

  String? get email => ConfigHelper.get('email');
  set email(String? value) => ConfigHelper.set('email', value);

  String? get password => ConfigHelper.get('password');
  set password(String? value) => ConfigHelper.set('password', value);

  bool get autoEat => ConfigHelper.get('autoEat') ?? false;
  set autoEat(bool value) => ConfigHelper.set('autoEat', value);

  bool get autoThrow => ConfigHelper.get('autoThrow') ?? false;
  set autoThrow(bool value) => ConfigHelper.set('autoThrow', value);

  bool get autoReconnect => ConfigHelper.get('autoReconnect') ?? true;
  set autoReconnect(bool value) => ConfigHelper.set('autoReconnect', value);

  BotActionType get botAction => BotActionType.values
      .byName(ConfigHelper.get('botAction') ?? BotActionType.none.name);
  set botAction(BotActionType value) =>
      ConfigHelper.set('botAction', value.name);

  String? get backgroundPath => ConfigHelper.get('backgroundPath');
  set backgroundPath(String? value) =>
      ConfigHelper.set('backgroundPath', value);

  // 公共設施頻道自動宣傳
  String? get warpPublicity => ConfigHelper.get('warpPublicity');
  set warpPublicity(String? value) => ConfigHelper.set('warpPublicity', value);

  // 交易頻道自動宣傳
  String? get tradePublicity => ConfigHelper.get('tradePublicity');
  set tradePublicity(String? value) =>
      ConfigHelper.set('tradePublicity', value);

  bool get hideHealth => ConfigHelper.get('hideHealth') ?? true;
  set hideHealth(bool value) => ConfigHelper.set('hideHealth', value);

  Map toMap() => {
        'region': region.name,
        'autoEat': autoEat,
        'autoThrow': autoThrow,
        'autoReconnect': autoReconnect,
        'botAction': botAction.name,
        'backgroundPath': backgroundPath,
        'warpPublicity': warpPublicity,
        'tradePublicity': tradePublicity,
        'hideHealth': hideHealth,
      };
}
