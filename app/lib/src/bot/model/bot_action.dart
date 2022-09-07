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
  afk(true),
  command(false),
  attack(true),
  updateConfig(false),
  disconnect(false);

  // If true, this action cannot be executed simultaneously with other actions.
  final bool only;

  const BotActionType(this.only);

  String getName() {
    switch (this) {
      case BotActionType.afk:
        return '掛機';
      case BotActionType.attack:
        return '自動攻擊生物';
      default:
        return name;
    }
  }

  String getTooltip() {
    switch (this) {
      case BotActionType.attack:
        return '自動攻擊敵對生物，可以用在突襲塔、終界使者經驗塔、烈焰使者農場等地方';
      default:
        return getName();
    }
  }
}

enum BotActionMethod {
  start,
  stop,
}
