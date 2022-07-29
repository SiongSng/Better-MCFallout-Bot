import 'package:better_mcfallout_bot/src/config/server_region.dart';

import 'config.dart';

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
}
