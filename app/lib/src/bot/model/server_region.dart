import 'package:dart_minecraft/dart_minecraft.dart' as mc;

enum ServerRegion {
  auto('mcfallout.net'),
  initial('mcfallout.net'),

  /// North America
  na('na.mcfallout.net'),

  /// Japan
  japan('jp.mcfallout.net'),

  denpa('denpa.mcfallout.net'),
  mercy('mercy.mcfallout.net');

  final String host;
  const ServerRegion(this.host);

  String getName() {
    switch (this) {
      case ServerRegion.auto:
        return '自動分配';
      case ServerRegion.initial:
        return '初始 (mcfallout.net)';
      case ServerRegion.na:
        return '北美洲';
      case ServerRegion.japan:
        return '日本';
      case ServerRegion.denpa:
        return 'Denpa';
      case ServerRegion.mercy:
        return 'Mercy';
    }
  }

  static Future<String> getBestHost() async {
    try {
      const hosts = [
        'mcfallout.net',
        'na.mcfallout.net',
        'jp.mcfallout.net',
        'mercy.mcfallout.net'
      ];

      final Map<String, int> result = {};

      for (final host in hosts) {
        try {
          final packet =
              await mc.ping(host, timeout: const Duration(seconds: 1));
          final ping = packet?.ping;
          if (ping != null) {
            result[host] = ping;
          }
        } catch (e) {
          // no-op
        }
      }

      final bestHost =
          result.entries.reduce((a, b) => a.value < b.value ? a : b).key;

      return bestHost;
    } catch (e) {
      return 'mcfallout.net';
    }
  }
}
