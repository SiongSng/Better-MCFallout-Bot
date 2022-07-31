class BotAction {
  final BotActionType action;
  final BotActionMethod method;
  final Map<String, dynamic>? argument;

  const BotAction({
    required this.action,
    this.method = BotActionMethod.start,
    this.argument,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action.name,
      'method': method.name,
      'argument': argument,
    };
  }

  factory BotAction.fromMap(Map<String, dynamic> map) {
    return BotAction(
      action: BotActionType.values.byName(map['action']),
      method: BotActionMethod.values.byName(map['method']),
      argument: map['argument'] != null
          ? Map<String, dynamic>.from(map['argument'])
          : null,
    );
  }
}

enum BotActionType {
  none(true),
  command(false),
  raid(true),
  updateConfig(false),
  disconnect(false);

  // If true, this action cannot be executed simultaneously with other actions.
  final bool only;

  const BotActionType(this.only);

  String getName() {
    switch (this) {
      case BotActionType.none:
        return '無 (掛機)';
      case BotActionType.raid:
        return '自動刷突襲塔';
      default:
        return '';
    }
  }
}

enum BotActionMethod {
  start,
  stop,
}
