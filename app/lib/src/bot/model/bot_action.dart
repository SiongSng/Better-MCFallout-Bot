class BotAction {
  final BotActionType action;
  final Map<String, dynamic> argument;

  const BotAction({
    required this.action,
    required this.argument,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action.name,
      'argument': argument,
    };
  }

  factory BotAction.fromMap(Map<String, dynamic> map) {
    return BotAction(
      action: BotActionType.values.byName(map['action']),
      argument: Map<String, dynamic>.from(map['argument']),
    );
  }
}

enum BotActionType {
  none,
  command,
  raid;

  String getName() {
    switch (this) {
      case BotActionType.none:
        return '無 (掛機)';
      case BotActionType.raid:
        return '自動刷突襲塔';
      case BotActionType.command:
        return '';
    }
  }
}
