export interface BotAction {
  action: BotActionType;
  argument?: Record<string, unknown>;
}

export enum BotActionType {
  none = "none",
  raid = "raid",
  command = "command",
}
