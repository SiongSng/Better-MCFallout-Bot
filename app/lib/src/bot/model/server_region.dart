enum ServerRegion {
  auto,

  /// North America
  na,

  /// Japan
  japan;

  String getHost() {
    switch (this) {
      case ServerRegion.auto:
        return 'mcfallout.net';
      case ServerRegion.na:
        return 'na.mcfallout.net';
      case ServerRegion.japan:
        return 'jp.mcfallout.net';
    }
  }

  String getName() {
    switch (this) {
      case ServerRegion.auto:
        return '自動分配';
      case ServerRegion.na:
        return '北美洲';
      case ServerRegion.japan:
        return '日本';
    }
  }
}
