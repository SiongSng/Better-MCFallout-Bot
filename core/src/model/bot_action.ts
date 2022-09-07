export interface BotAction {
  action: BotActionType;
  method: BotActionMethod;
  argument?: Record<string, unknown>;
}

export enum BotActionType {
  afk = "afk",
  attack = "attack",
  command = "command",
  updateConfig = "updateConfig",
  disconnect = "disconnect",
}

export enum BotActionMethod {
  start = "start",
  stop = "stop",
}
