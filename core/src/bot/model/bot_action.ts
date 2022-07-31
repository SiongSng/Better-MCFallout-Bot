export interface BotAction {
  action: BotActionType;
  method: BotActionMethod;
  argument?: Record<string, unknown>;
}

export enum BotActionType {
  none = "none",
  raid = "raid",
  command = "command",
  updateConfig = "updateConfig",
  disconnect = "disconnect",
}

export enum BotActionMethod {
  start = "start",
  stop = "stop",
}
