enum BotAction {
  none,
  command,
  raid;

  String getName() {
    switch (this) {
      case BotAction.none:
        return '無 (掛機)';
      case BotAction.raid:
        return '自動刷突襲塔';
      case BotAction.command:
        return '';
    }
  }
}
